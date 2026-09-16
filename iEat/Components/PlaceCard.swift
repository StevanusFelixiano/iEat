//
//  PlaceCard.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct PlaceCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let imageName: String
    let name: String
    let category: String
    let rating: String
    let reviews: String
    let distance: String
    let closingTime: String

    var body: some View {

        VStack(spacing: 0) {

            // MARK: Image

            ZStack(alignment: .topTrailing) {

                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 210)
                    .frame(maxWidth: .infinity)
                    .clipped()

                // Open status

                Text("Open · \(closingTime)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 11)
                    .background(
                        Capsule()
                            .fill(Color.green)
                    )
                    .padding(.top, 18)
                    .padding(.trailing, 18)
            }

            // MARK: Information

            VStack(alignment: .leading, spacing: 8) {

                HStack {

                    Text(name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(.systemGray3))
                }

                Text(category)
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)

                HStack(spacing: 7) {

                    Image(systemName: "star.fill")
                        .font(.system(size: 17))
                        .foregroundStyle(.orange)

                    Text(rating)
                        .font(.system(size: 18, weight: .semibold))

                    Text("(\(reviews))")
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)

                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(.systemGray3))
                        .padding(.leading, 7)

                    Text(distance)
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)
                }
                .padding(.top, 8)
            }
            .padding(.trailing, 18)
            .padding(.leading, 22)
            .padding(.vertical, 22)
        }
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    colorScheme == .dark
                    ? Color(.secondarySystemBackground)
                    : Color(.systemBackground)
                )
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 28)
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 5
        )
    }
}
