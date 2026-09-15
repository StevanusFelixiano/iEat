//
//  ExploreScreen.swift
//  iEat
//
//  Created by Stevanus Felixiano on 14/09/26.
//

import SwiftUI

struct ExploreScreen: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var manager = CulinaryManager()

    var body: some View {

        ZStack {

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

                        // List / Map

                        HStack(spacing: 0) {

                            HStack(spacing: 5) {

                                Image(systemName: "line.3.horizontal")

                                Text("List")
                            }
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                                    .shadow(
                                        color: .black.opacity(0.08),
                                        radius: 3,
                                        y: 1
                                    )
                            )

                            HStack(spacing: 5) {

                                Image(systemName: "square.grid.2x2.fill")

                                Text("Map")
                            }
                            .foregroundStyle(Color(.systemGray))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
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

                            Text("Rice near you")
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

                            // Open filter

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

                    // MARK: Place Card

                    ForEach(manager.places) { place in

                        if let restaurant = place as? Restaurant {

                            PlaceCard(
                                imageName: "nasiPadang",
                                name: restaurant.name,
                                category: "\(restaurant.category) · \(restaurant.cuisine)",
                                rating: restaurant.rating.map {
                                    String(format: "%.1f", $0)
                                } ?? "-",
                                reviews: restaurant.reviewCount.map {
                                    String($0)
                                } ?? "No reviews",
                                distance: "\(Int(restaurant.distance)) m",
                                closingTime: closingTime(
                                    from: restaurant.openingHours
                                )
                            )
                            .padding(.top, 22)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
            }
        }
        .navigationBarBackButtonHidden(true)
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
    ExploreScreen()
}
