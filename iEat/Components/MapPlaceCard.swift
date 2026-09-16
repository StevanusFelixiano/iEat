//
//  MapPlaceCard.swift
//  iEat
//
//  Created by Stevanus Felixiano on 16/09/26.
//

import SwiftUI

struct MapPlaceCard: View {
    let restaurant: Restaurant
    let closingTime: String

    var body: some View {
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
            closingTime: closingTime
        )
    }
}
