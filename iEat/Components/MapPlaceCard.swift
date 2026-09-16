//
//  MapPlaceCard.swift
//  iEat
//
//  Created by Stevanus Felixiano on 16/09/26.
//

import SwiftUI

struct MapPlaceCard: View {
    @Environment(\.colorScheme) private var colorScheme

    let restaurant: Restaurant
    let closingTime: String
    
    private var isOpen: Bool {
        guard let openingHours = restaurant.openingHours else {
            return true
        }

        let times = openingHours
            .replacingOccurrences(of: "Daily ", with: "")
            .components(separatedBy: "–")

        guard times.count == 2 else {
            return true
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
            return true
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

    private var statusText: String {
        guard let openingHours = restaurant.openingHours else {
            return "Open · Hours unavailable"
        }

        return isOpen ? "Open" : "Closed"
    }

    var body: some View {
        HStack(spacing: 16) {

            // MARK: Image
            Image("nasiPadang")
                .resizable()
                .scaledToFill()
                .frame(width: 82, height: 82)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )

            // MARK: Information
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(restaurant.name)
                        .font(
                            .system(
                                size: 17,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            Color(.systemGray3)
                        )
                }

                Text(
                    restaurant.category
                    + " · "
                    + (restaurant.placeType ?? "Place")
                )
                .font(.system(size: 15))
                .foregroundStyle(.gray)
                .lineLimit(1)

                HStack(spacing: 4) {
                    if let rating = restaurant.rating {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.orange)

                            Text(
                                String(
                                    format: "%.1f",
                                    rating
                                )
                            )
                            .font(
                                .system(
                                    size: 15,
                                    weight: .semibold
                                )
                            )
                        }
                    } else {
                        Text("No rating")
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }

                    Text(
                        "· \(Int(restaurant.distance)) m"
                    )
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)

                    Spacer()

                    Text(statusText)
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                        .background(
                            Capsule()
                                .fill(isOpen ? Color.green : Color.red)
                        )
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    colorScheme == .dark
                    ? Color(.secondarySystemBackground)
                    : Color(.systemBackground)
                )
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 10,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    MapPlaceCard(
        restaurant: nasiPadang,
        closingTime: "Closes 21:00"
    )
    .padding()
}
