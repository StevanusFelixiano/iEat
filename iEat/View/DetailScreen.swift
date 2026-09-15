//
//  DetailScreen.swift
//  iEat
//
//  Created by Stevanus Felixiano on 14/09/26.
//

import SwiftUI

struct DetailScreen: View {

    @Environment(\.dismiss) private var dismiss

    // Data comes from the model
    let place = nasiPadang

    var body: some View {

        ZStack(alignment: .bottom) {

            Color(red: 0.98, green: 0.98, blue: 0.97)
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
                                        .fill(.white)
                                )
                        }
                        .padding(.top, 56)
                        .padding(.leading, 40)
                        .tint(.primary)

                        // Open Status

                        Text("Open · \(closingTime)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(Color.green)
                            )
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

                        Text("\(place.category) · \(place.cuisine)")
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 5)

                        // Rating

                        HStack(spacing: 5) {

                            ForEach(0..<5, id: \.self) { _ in

                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.orange)
                            }

                            Text(
                                place.rating.map {
                                    String(format: "%.1f", $0)
                                } ?? "-"
                            )
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 7)

                            Text(
                                place.reviewCount.map {
                                    "· \($0) reviews"
                                } ?? "· No reviews"
                            )
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                        }
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

                        HStack(alignment: .top, spacing: 16) {

                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.orange)
                                .padding(.top, 11)

                            VStack(alignment: .leading, spacing: 5) {

                                Text("Address")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gray)

                                Text(place.address)
                                    .font(.system(size: 16))
                                    .foregroundStyle(.primary)
                            }

                            Spacer()
                        }

                        Divider()
                            .padding(.leading, 36)
                            .padding(.vertical, 14)

                        // Hours

                        HStack(alignment: .top, spacing: 16) {

                            Image(systemName: "clock")
                                .font(.system(size: 20))
                                .foregroundStyle(.orange)
                                .padding(.top, 11)

                            VStack(alignment: .leading, spacing: 5) {

                                Text("Hours")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gray)

                                Text(
                                    place.openingHours
                                    ?? "Hours unavailable"
                                )
                                .font(.system(size: 16))
                                .foregroundStyle(.primary)
                            }

                            Spacer()
                        }
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

                    ZStack {

                        // Simple map background

                        Color(red: 0.82, green: 0.87, blue: 0.76)

                        // Roads

                        Path { path in

                            // Vertical roads

                            path.move(to: CGPoint(x: 70, y: 0))
                            path.addLine(to: CGPoint(x: 70, y: 230))

                            path.move(to: CGPoint(x: 140, y: 0))
                            path.addLine(to: CGPoint(x: 140, y: 230))

                            path.move(to: CGPoint(x: 210, y: 0))
                            path.addLine(to: CGPoint(x: 210, y: 230))

                            path.move(to: CGPoint(x: 280, y: 0))
                            path.addLine(to: CGPoint(x: 280, y: 230))

                            path.move(to: CGPoint(x: 358, y: 0))
                            path.addLine(to: CGPoint(x: 358, y: 230))

                            // Horizontal roads

                            path.move(to: CGPoint(x: 0, y: 45))
                            path.addLine(to: CGPoint(x: 360, y: 45))

                            path.move(to: CGPoint(x: 0, y: 90))
                            path.addLine(to: CGPoint(x: 360, y: 90))

                            path.move(to: CGPoint(x: 0, y: 135))
                            path.addLine(to: CGPoint(x: 360, y: 135))

                            path.move(to: CGPoint(x: 0, y: 180))
                            path.addLine(to: CGPoint(x: 360, y: 180))

                            path.move(to: CGPoint(x: 0, y: 225))
                            path.addLine(to: CGPoint(x: 360, y: 225))
                        }
                        .stroke(
                            Color.white.opacity(0.95),
                            lineWidth: 4
                        )

                        // Place label

                        VStack(spacing: 4) {

                            Text(place.name)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 17)
                                .padding(.vertical, 11)
                                .background(
                                    Capsule()
                                        .fill(Color.orange)
                                )

                            Circle()
                                .fill(Color.orange)
                                .frame(width: 12, height: 12)
                        }
                    }
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

                // Open Maps

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
}

#Preview {
    DetailScreen()
}
