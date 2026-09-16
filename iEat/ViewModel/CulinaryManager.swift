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
    @Published var places: [Place] = []
    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var locationName = "Finding location..."

    private let locationManager = CLLocationManager()

    private var currentSearch: MKLocalSearch?
    private var hasReceivedLocation = false

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
        hasReceivedLocation = false
        locationManager.startUpdatingLocation()
    }

    private func handleLocation(_ location: CLLocation) {

        // Only use the first location
        guard !hasReceivedLocation else {
            return
        }

        hasReceivedLocation = true

        // We only need the user's initial location
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
                }

            } catch {

                await MainActor.run {
                    self.locationName = "Location unavailable"
                }
            }
        }
    }

    // MARK: - Craving

    func selectCraving(_ craving: FoodPreference) {

        selectedCraving = craving
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

                    self.places = sortedResults
                    self.isSearching = false
                    self.currentSearch = nil
                }

            } catch {

                await MainActor.run {

                    self.places = []
                    self.isSearching = false
                    self.errorMessage = error.localizedDescription
                    self.currentSearch = nil
                }
            }
        }
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

        return Restaurant(
            name: name,
            address: address,
            distance: distance,
            category: craving.name,
            coordinate: coordinate,
            cuisine: "Nearby",
            phoneNumber: item.phoneNumber,
            websiteURL: item.url
        )
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
