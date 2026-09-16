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
            if let rating {
                ForEach(0..<5, id: \.self) { index in
                    Image(
                        systemName: starName(
                            for: rating,
                            at: index
                        )
                    )
                    .font(.system(size: 8))
                    .foregroundStyle(.orange)
                }

                Text(
                    String(
                        format: "%.1f",
                        rating
                    )
                )
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .padding(.leading, 7)

                Text(
                    reviewCount.map {
                        "· \($0) reviews"
                    } ?? "· No reviews"
                )
                .font(.system(size: 16))
                .foregroundStyle(.gray)

            } else {
                Text("No Rating")
                    .font(.system(size: 16, weight: .semibold))

                Text("· No Review")
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
            }
        }
    }
    private func starName(
            for rating: Double,
            at index: Int
        ) -> String {
            if Double(index) < floor(rating) {
                return "star.fill"
            }

            if Double(index) < rating {
                return "star.leadinghalf.filled"
            }

            return "star"
        }
}
