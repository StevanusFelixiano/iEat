//
//  CulinaryManager.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import Foundation
import Combine
import MapKit
import CoreLocation

final class CulinaryManager: NSObject, ObservableObject {

    @Published var selectedCraving: FoodPreference?

    // Final results shown by ExploreScreen
    @Published var places: [Place] = []

    // All results returned by MapKit
    private var allPlaces: [Place] = []

    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var locationName = "Finding location..."
    @Published var isRefreshingLocation = false

    private let locationManager = CLLocationManager()

    private var currentSearch: MKLocalSearch?
    private var hasReceivedLocation = false

    // MARK: - Active Filters

    @Published var selectedDistance: Double = 5
    @Published var selectedRating: Double? = nil
    @Published var openNow = false

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    // MARK: - Location

    func requestLocationPermission() {

        switch locationManager.authorizationStatus {

        case .authorizedWhenInUse,
             .authorizedAlways:

            locationManager.startUpdatingLocation()

        case .notDetermined:

            locationManager.requestWhenInUseAuthorization()

        default:

            locationName = "Location unavailable"
        }
    }

    func refreshLocation() {
        isRefreshingLocation = true
        hasReceivedLocation = false
        locationManager.startUpdatingLocation()
    }

    private func handleLocation(_ location: CLLocation) {

        guard !hasReceivedLocation else {
            return
        }

        hasReceivedLocation = true

        locationManager.stopUpdatingLocation()

        Task {

            do {

                guard let request = MKReverseGeocodingRequest(
                    location: location
                ) else {

                    await MainActor.run {
                        self.locationName = "Location unavailable"
                    }

                    return
                }

                let mapItems = try await request.mapItems

                guard let mapItem = mapItems.first else {

                    await MainActor.run {
                        self.locationName = "Location unavailable"
                    }

                    return
                }

                let locationName =
                    mapItem.addressRepresentations?.cityName
                    ?? mapItem.address?.shortAddress
                    ?? "Current location"

                await MainActor.run {
                    self.locationName = locationName
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.isRefreshingLocation = false
                        }
                }

            } catch {

                await MainActor.run {
                    self.locationName = "Location unavailable"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.isRefreshingLocation = false
                        }
                }
            }
        }
    }

    // MARK: - Craving

    func selectCraving(_ craving: FoodPreference) {
        selectedCraving = craving

        // Reset filters for the new craving
        selectedDistance = 5
        selectedRating = nil
        openNow = false

        searchPlaces(for: craving)
    }

    // MARK: - MapKit Search

    func searchPlaces(for craving: FoodPreference) {

        guard let coordinate = locationManager.location?.coordinate else {

            errorMessage = "Location is not available yet."
            return
        }

        isSearching = true
        errorMessage = nil

        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )

        var request = MKLocalSearch.Request()

        request.naturalLanguageQuery = craving.searchQuery
        request.region = region
        request.resultTypes = .pointOfInterest
        request.regionPriority = .required

        currentSearch?.cancel()

        let search = MKLocalSearch(request: request)
        currentSearch = search

        Task {

            do {

                let response = try await search.start()

                let results = response.mapItems.compactMap { mapItem in

                    mapItemToRestaurant(
                        mapItem,
                        craving: craving,
                        userCoordinate: coordinate
                    )
                }

                let sortedResults = results.sorted {
                    $0.distance < $1.distance
                }

                await MainActor.run {

                    self.allPlaces = sortedResults
                    self.applyFilters()

                    self.isSearching = false
                    self.currentSearch = nil
                }

            } catch {

                await MainActor.run {

                    self.allPlaces = []
                    self.places = []

                    self.isSearching = false
                    self.errorMessage = error.localizedDescription
                    self.currentSearch = nil
                }
            }
        }
    }

    // MARK: - Filters

    func applyFilters(
        distance: String,
        rating: String,
        openNow: Bool
    ) {

        selectedDistance = distanceValue(from: distance)
        selectedRating = ratingValue(from: rating)
        self.openNow = openNow

        applyFilters()
    }

    private func applyFilters() {

        let maxDistance = selectedDistance * 1000

        places = allPlaces.filter { place in

            // Distance
            guard place.distance <= maxDistance else {
                return false
            }

            // Rating
            if let minimumRating = selectedRating {

                guard let rating = place.rating else {
                    return false
                }

                guard rating >= minimumRating else {
                    return false
                }
            }

            // Open Now
            if openNow {

                guard let hours = place.openingHours else {
                    return false
                }

                guard isCurrentlyOpen(hours) else {
                    return false
                }
            }

            return true
        }
    }

    // MARK: - Distance Filter

    private func distanceValue(from value: String) -> Double {

        switch value {

        case "1 km":
            return 1

        case "2 km":
            return 2

        case "5 km":
            return 5

        case "10 km":
            return 10

        case "20 km":
            return 20

        default:
            return 5
        }
    }

    // MARK: - Rating Filter

    private func ratingValue(from value: String) -> Double? {

        switch value {

        case "Any":
            return nil

        case "3+":
            return 3

        case "3.5+":
            return 3.5

        case "4+":
            return 4

        case "4.5+":
            return 4.5

        default:
            return nil
        }
    }

    // MARK: - Open Now

    private func isCurrentlyOpen(_ hours: String) -> Bool {

        let times = hours
            .replacingOccurrences(of: "Daily ", with: "")
            .components(separatedBy: "–")

        guard times.count == 2 else {
            return false
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard
            let openingTime = formatter.date(
                from: times[0].trimmingCharacters(in: .whitespaces)
            ),
            let closingTime = formatter.date(
                from: times[1].trimmingCharacters(in: .whitespaces)
            )
        else {
            return false
        }

        let calendar = Calendar.current
        let now = Date()

        let currentMinutes =
            calendar.component(.hour, from: now) * 60
            + calendar.component(.minute, from: now)

        let openingMinutes =
            calendar.component(.hour, from: openingTime) * 60
            + calendar.component(.minute, from: openingTime)

        let closingMinutes =
            calendar.component(.hour, from: closingTime) * 60
            + calendar.component(.minute, from: closingTime)

        return currentMinutes >= openingMinutes
            && currentMinutes < closingMinutes
    }

    // MARK: - MapItem → Restaurant

    private func mapItemToRestaurant(
        _ item: MKMapItem,
        craving: FoodPreference,
        userCoordinate: CLLocationCoordinate2D
    ) -> Restaurant? {

        guard let name = item.name else {
            return nil
        }

        let coordinate = item.location.coordinate

        let distance = distanceBetween(
            from: userCoordinate,
            to: coordinate
        )

        let address =
            item.addressRepresentations?
                .fullAddress(
                    includingRegion: false,
                    singleLine: true
                )
            ?? item.address?.fullAddress
            ?? "Address unavailable"
        
        let placeType = placeTypeName(
            from: item.pointOfInterestCategory
        )

        return Restaurant(
            name: name,
            address: address,
            distance: distance,
            category: craving.name,
            placeType: placeType,
            coordinate: coordinate,
            cuisine: "Nearby",
            phoneNumber: item.phoneNumber,
            websiteURL: item.url
        )
    }
    
    private func placeTypeName(
        from category: MKPointOfInterestCategory?
    ) -> String {
        switch category {
        case .restaurant:
            return "Restaurant"
        case .cafe:
            return "Cafe"
        case .bakery:
            return "Bakery"
        default:
            return "Place"
        }
    }
    
    // MARK: - Distance

    private func distanceBetween(
        from source: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    ) -> Double {

        let sourceLocation = CLLocation(
            latitude: source.latitude,
            longitude: source.longitude
        )

        let destinationLocation = CLLocation(
            latitude: destination.latitude,
            longitude: destination.longitude
        )

        return sourceLocation.distance(
            from: destinationLocation
        )
    }
}

// MARK: - CLLocationManagerDelegate

extension CulinaryManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {

        switch manager.authorizationStatus {

        case .authorizedWhenInUse,
             .authorizedAlways:

            manager.startUpdatingLocation()

        default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let firstLocation = locations.first else {
            return
        }

        handleLocation(firstLocation)
    }
}
