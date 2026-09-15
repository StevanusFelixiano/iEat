//
//  RatingView.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct RatingView: View {

    let rating: Double?
    let reviewCount: Int?

    var body: some View {

        HStack(spacing: 5) {

            ForEach(0..<5, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(.orange)
            }

            Text(
                rating.map {
                    String(format: "%.1f", $0)
                } ?? "-"
            )
            .font(.system(size: 16, weight: .semibold))
            .padding(.leading, 7)

            Text(
                reviewCount.map {
                    "· \($0) reviews"
                } ?? "· No reviews"
            )
            .font(.system(size: 16))
            .foregroundStyle(.gray)
        }
    }
}
