//
//  ExploreScreen.swift
//  iEat
//
//  Created by Stevanus Felixiano on 14/09/26.
//

import SwiftUI
import MapKit

struct ExploreScreen: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var manager: CulinaryManager
    
    @State private var showFilters = false
    @State private var filterOffset: CGFloat = 560
    @State private var isMapView = false
    @State private var mapPosition: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack {
            // MARK: - Main Explore Content
            
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: Top Bar
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "chevron.left")
                                
                                Text("Discover")
                            }
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(.orange)
                        }
                        
                        Spacer()
                        
                        // MARK: List / Map
                        
                        HStack(spacing: 0) {
                            Button {
                                isMapView = false
                            } label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "line.3.horizontal")
                                    
                                    Text("List")
                                }
                                .foregroundStyle(
                                    isMapView
                                    ? Color(.systemGray)
                                    : .primary
                                )
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            isMapView
                                            ? Color.clear
                                            : Color(.systemBackground)
                                        )
                                        .shadow(
                                            color: isMapView
                                            ? .clear
                                            : .black.opacity(0.08),
                                            radius: 3,
                                            x: 0,
                                            y: 1
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                            
                            Button {
                                isMapView = true
                                mapPosition = .automatic
                            } label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "square.grid.2x2.fill")
                                    
                                    Text("Map")
                                }
                                .foregroundStyle(
                                    isMapView
                                    ? .primary
                                    : Color(.systemGray)
                                )
                                .padding(.horizontal, 10)
                                .padding(.vertical, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            isMapView
                                            ? Color(.systemBackground)
                                            : Color.clear
                                        )
                                        .shadow(
                                            color: isMapView
                                            ? .black.opacity(0.08)
                                            : .clear,
                                            radius: 3,
                                            x: 0,
                                            y: 1
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .padding(3)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                    
                    // MARK: Title
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(
                                "\(manager.selectedCraving?.name ?? "Food") near you"
                            )
                            .font(
                                .system(
                                    size: 28,
                                    weight: .bold,
                                    design: .serif
                                )
                            )
                            .foregroundStyle(.primary)
                            
                            Text("\(manager.places.count) place found")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                                .padding(.top, 4)
                        }
                        
                        Spacer()
                        
                        Button {
                            filterOffset = 560
                            showFilters = true

                            withAnimation(.linear(duration: 0.2)) {
                                filterOffset = 0
                            }
                            
                        } label: {
                            HStack(spacing: 8) {
                                Image(
                                    systemName:
                                        "line.3.horizontal.decrease"
                                )
                                
                                Text("Filter")
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color(.systemGray6))
                            )
                        }
                    }
                    .padding(.top, 32)
                    .tint(.primary)
                    
                    // MARK: Results
                    
                    if isMapView {
                        ZStack(alignment: .bottom) {
                            Map(position: $mapPosition) {
                                ForEach(manager.places) { place in
                                    if let restaurant = place as? Restaurant {
                                        Marker(
                                            restaurant.name,
                                            coordinate: restaurant.coordinate
                                        )
                                        .tint(.orange)
                                    }
                                }
                            }
                            .mapStyle(.standard)
                            .frame(height: 500)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 28)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(
                                        Color.black.opacity(0.06),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(
                                color: .black.opacity(0.08),
                                radius: 10,
                                x: 0,
                                y: 4
                            )

                            if let restaurant = manager.places.first as? Restaurant {
                                MapPlaceCard(
                                    restaurant: restaurant,
                                    closingTime: closingTime(
                                        from: restaurant.openingHours
                                    )
                                )
                                .padding(.horizontal, 12)
                                .padding(.bottom, 12)
                            }
                        }
                        .padding(.top, 22)
                    } else {
                        // MARK: Place Card
                        
                        ForEach(manager.places) { place in
                            if let restaurant = place as? Restaurant {
                                PlaceCard(
                                    imageName: "nasiPadang",
                                    name: restaurant.name,
                                    category:
                                        "\(restaurant.category) · \(restaurant.cuisine)",
                                    rating: restaurant.rating.map {
                                        String(format: "%.1f", $0)
                                    } ?? "-",
                                    reviews: restaurant.reviewCount.map {
                                        String($0)
                                    } ?? "No reviews",
                                    distance:
                                        "\(Int(restaurant.distance)) m",
                                    closingTime: closingTime(
                                        from: restaurant.openingHours
                                    )
                                )
                                .padding(.top, 22)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
            }
            
            // MARK: Custom Filter Sheet
            
            if showFilters {
                filterOverlay
                    .zIndex(10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Custom Filter Overlay
    
    private var filterOverlay: some View {
        ZStack {
            // Background
            Color.black
                .opacity(0.25)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.linear(duration: 0.2)) {
                        filterOffset = 560
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showFilters = false
                    }
                }
            
            // Sheet
            VStack(spacing: 0) {
                Spacer()
                
                FilterSheet(
                    onDismiss: {
                        withAnimation(.linear(duration: 0.2)) {
                            filterOffset = 560
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showFilters = false
                        }
                    },
                    onApply: { distance, rating, openNow in
                        manager.applyFilters(
                            distance: distance,
                            rating: rating,
                            openNow: openNow
                        )
                        
                        withAnimation(.linear(duration: 0.2)) {
                            showFilters = false
                        }
                    }
                )
                .frame(maxWidth: .infinity)
                .frame(height: 560)
                .background(Color(.systemBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 28)
                )
                .offset(y: filterOffset)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    // MARK: - Helper
    
    private func closingTime(from openingHours: String?) -> String {
        guard let openingHours else {
            return "Hours unavailable"
        }
        
        if let range = openingHours.split(separator: "–").last {
            return "Closes \(range.trimmingCharacters(in: .whitespaces))"
        }
        
        return "Hours unavailable"
    }
}

#Preview {
    ExploreScreen(manager: CulinaryManager())
}
