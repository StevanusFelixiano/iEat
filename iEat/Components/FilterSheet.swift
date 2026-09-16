//
//  FilterSheet.swift
//  iEat
//
//  Created by Stevanus Felixiano on 16/09/26.
//

import SwiftUI

struct FilterSheet: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedDistance = "5 km"
    @State private var selectedRating = "Any"
    @State private var openNow = false

    let onApply: (
        String,
        String,
        Bool
    ) -> Void

    private let distances = [
        "1 km",
        "2 km",
        "5 km",
        "10 km",
        "20 km"
    ]

    private let ratings = [
        "Any",
        "3+",
        "3.5+",
        "4+",
        "4.5+"
    ]

    var body: some View {

        VStack(spacing: 0) {

            // MARK: Header

            HStack {

                Text("Filters")
                    .font(
                        .system(
                            size: 32,
                            weight: .bold,
                            design: .serif
                        )
                    )

                Spacer()

                Button {
                    dismiss()
                } label: {

                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle()
                                .fill(Color(.systemGray6))
                        )
                }
            }

            Divider()
                .padding(.top, 22)

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 0) {

                    // MARK: Distance

                    Text("DISTANCE")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.top, 36)

                    FlowLayout(spacing: 12) {

                        ForEach(distances, id: \.self) { distance in

                            FilterChip(
                                title: distance,
                                isSelected: selectedDistance == distance
                            ) {
                                selectedDistance = distance
                            }
                        }
                    }
                    .padding(.top, 20)

                    Divider()
                        .padding(.top, 30)

                    // MARK: Rating

                    Text("MINIMUM RATING")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.top, 36)

                    FlowLayout(spacing: 12) {

                        ForEach(ratings, id: \.self) { rating in

                            FilterChip(
                                title: rating,
                                isSelected: selectedRating == rating
                            ) {
                                selectedRating = rating
                            }
                        }
                    }
                    .padding(.top, 20)

                    Divider()
                        .padding(.top, 30)

                    // MARK: Open Now

                    HStack {

                        VStack(alignment: .leading, spacing: 5) {

                            Text("Open Now")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundStyle(.primary)

                            Text("Show only currently open places")
                                .font(.system(size: 18))
                                .foregroundStyle(.gray)
                        }

                        Spacer()

                        Toggle("", isOn: $openNow)
                            .labelsHidden()
                            .tint(.orange)
                    }
                    .padding(.top, 32)

                    // MARK: Apply

                    Button {

                        onApply(
                            selectedDistance,
                            selectedRating,
                            openNow
                        )

                        dismiss()

                    } label: {

                        Text("Apply Filters")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 64)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.orange)
                            )
                    }
                    .padding(.top, 36)
                    .padding(.bottom, 20)
                }
            }
        }
        .padding(.horizontal, 21)
        .padding(.top, 8)
    }
}

struct FlowLayout: Layout {

    var spacing: CGFloat = 12

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        let maxWidth = proposal.width ?? .infinity

        var width: CGFloat = 0
        var height: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {

            let size = subview.sizeThatFits(
                ProposedViewSize(width: maxWidth, height: nil)
            )

            if width + size.width > maxWidth {
                width = 0
                height += rowHeight + spacing
                rowHeight = 0
            }

            width += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        height += rowHeight

        return CGSize(
            width: maxWidth,
            height: height
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {

        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {

            let size = subview.sizeThatFits(
                ProposedViewSize(width: bounds.width, height: nil)
            )

            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(
                    x: x,
                    y: y
                ),
                proposal: ProposedViewSize(
                    width: size.width,
                    height: size.height
                )
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

struct FilterChip: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button {
            action()
        } label: {

            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(
                    isSelected
                    ? .white
                    : .primary
                )
                .padding(.horizontal, 24)
                .frame(height: 56)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                            ? Color.orange
                            : Color(.systemGray6)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}
