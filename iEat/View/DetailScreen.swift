//
//  DetailScreen.swift
//  iEat
//
//  Created by Stevanus Felixiano on 14/09/26.
//

import SwiftUI
import MapKit

struct DetailScreen: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Data
    let place: Restaurant
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(
                colorScheme == .dark
                ? Color(red: 0.08, green: 0.08, blue: 0.08)
                : Color(red: 0.98, green: 0.98, blue: 0.97)
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: Hero Image
                    
                    ZStack(alignment: .topLeading) {
                        Image("nasiPadang")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                        
                        // Back Button
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.primary)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(
                                            colorScheme == .dark
                                            ? Color(.secondarySystemBackground)
                                            : .white
                                        )
                                )
                        }
                        .padding(.top, 56)
                        .padding(.leading, 40)
                        .tint(.primary)
                        
                        // Open Status
                        
                        StatusBadge(openingHours: place.openingHours)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .trailing
                            )
                            .padding(.top, 243)
                            .padding(.trailing, 40)
                    }
                    
                    // MARK: Main Information
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(place.name)
                            .font(
                                .system(
                                    size: 26,
                                    weight: .bold,
                                    design: .serif
                                )
                            )
                            .foregroundStyle(.primary)
                            .padding(.leading, 5)
                        
                        Text(
                            place.category
                            + " · "
                            + (place.placeType ?? "Place")
                        )
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        
                        // Rating
                        
                        RatingView(
                            rating: place.rating,
                            reviewCount: place.reviewCount
                        )
                        .padding(.top, 16)
                        .padding(.leading, 5)
                        
                        // Distance
                        
                        HStack(spacing: 9) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(.gray))
                            
                            Text("\(Int(place.distance)) m away")
                                .font(.system(size: 16))
                                .foregroundStyle(Color(.gray))
                        }
                        .padding(.top, 13)
                        .padding(.leading, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 38)
                    .padding(.vertical, 34)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(.systemBackground))
                    )
                    
                    // MARK: Place Information
                    
                    VStack(spacing: 0) {
                        
                        // Address
                        
                        PlaceInfo(
                            icon: "mappin.circle.fill",
                            title: "Address",
                            value: place.address
                        )
                        
                        Divider()
                            .padding(.leading, 36)
                            .padding(.vertical, 14)
                        
                        // Hours
                        
                        PlaceInfo(
                            icon: "clock",
                            title: "Hours",
                            value: place.openingHours ?? "Hours unavailable"
                        )
                        
                        Divider()
                            .padding(.leading, 36)
                            .padding(.vertical, 14)
                        
                        PlaceInfo(
                            icon: "phone.fill",
                            title: "Phone",
                            value: place.phoneNumber ?? "Phone unavailable"
                        )
                        
                        Divider()
                            .padding(.leading, 36)
                            .padding(.vertical, 14)
                        
                        PlaceInfo(
                            icon: "globe",
                            title: "Website",
                            value: place.websiteURL?.absoluteString ?? "Website unavailable"
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.systemBackground))
                            .shadow(
                                color: .black.opacity(0.06),
                                radius: 8,
                                x: 0,
                                y: 3
                            )
                    )
                    .padding(.horizontal, 44)
                    .padding(.top, 20)
                    
                    // MARK: Map Preview
                    
                    Map(
                        initialPosition: .region(
                            MKCoordinateRegion(
                                center: place.coordinate,
                                latitudinalMeters: 800,
                                longitudinalMeters: 800
                            )
                        )
                    ) {
                        Marker(
                            place.name,
                            coordinate: place.coordinate
                        )
                        .tint(.orange)
                    }
                    .mapStyle(.standard)
                    .frame(height: 180)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                Color.black.opacity(0.06),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: .black.opacity(0.08),
                        radius: 8,
                        x: 0,
                        y: 3
                    )
                    .padding(.horizontal, 44)
                    .padding(.top, 20)
                    
                    // Extra space for bottom button
                    
                    Color.clear
                        .frame(height: 100)
                }
            }
            
            // MARK: Directions Button
            
            Button {
                openDirections()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 22, weight: .medium))
                    
                    Text("Get Directions")
                        .font(.system(size: 21, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.orange)
                )
            }
            .padding(.horizontal, 56)
            .padding(.bottom, 10)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Computed Property
    
    private var closingTime: String {
        guard let openingHours = place.openingHours else {
            return "Hours unavailable"
        }
        
        if let closingTime = openingHours.split(separator: "–").last {
            return "Closes \(closingTime.trimmingCharacters(in: .whitespaces))"
        }
        
        return "Hours unavailable"
    }
    
    private func openDirections() {
        let destination = MKMapItem(
            location: CLLocation(
                latitude: place.coordinate.latitude,
                longitude: place.coordinate.longitude
            ),
            address: nil
        )
        
        destination.name = place.name
        
        destination.openInMaps(
            launchOptions: [
                MKLaunchOptionsDirectionsModeKey:
                    MKLaunchOptionsDirectionsModeDefault
            ]
        )
    }
}

#Preview {
    DetailScreen(place: nasiPadang)
}
