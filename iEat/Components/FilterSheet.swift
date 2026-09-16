//
//  FilterSheet.swift
//  iEat
//
//  Created by Stevanus Felixiano on 16/09/26.
//

import SwiftUI

struct FilterSheet: View {
    @State private var currentDistance: String
    @State private var currentRating: String
    @State private var currentOpenNow: Bool

    let onDismiss: () -> Void
    let onApply: (
        String,
        String,
        Bool
    ) -> Void

    init(
        selectedDistance: String,
        selectedRating: String,
        openNow: Bool,
        onDismiss: @escaping () -> Void,
        onApply: @escaping (
            String,
            String,
            Bool
        ) -> Void
    ) {
        _currentDistance = State(
            initialValue: selectedDistance
        )
        _currentRating = State(
            initialValue: selectedRating
        )
        _currentOpenNow = State(
            initialValue: openNow
        )

        self.onDismiss = onDismiss
        self.onApply = onApply
    }
    
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
            Capsule()
                .fill(Color(.systemGray3))
                .frame(width: 44, height: 5)
            // MARK: Header
            
            HStack {
                
                Text("Filters")
                    .font(
                        .system(
                            size: 24,
                            weight: .bold,
                            design: .serif
                        )
                    )
                
                Spacer()
                
                Button {
                    onDismiss()
                } label: {
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color(.systemGray6))
                        )
                }
                .tint(.primary)
            }
            .padding(.top, 18)
            
            Divider()
                .frame(height: 1)
                .background(Color(.systemGray4))
                .padding(.top, 16)
            
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: Distance
                    
                    Text("DISTANCE")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.top, 24)
                    
                    FlowLayout(spacing: 12) {
                        
                        ForEach(distances, id: \.self) { distance in
                            
                            FilterChip(
                                title: distance,
                                isSelected: currentDistance == distance
                            ) {
                                currentDistance = distance
                            }
                        }
                    }
                    .padding(.top, 16)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color(.systemGray4))
                        .padding(.top, 24)
                    
                    // MARK: Rating
                    
                    Text("MINIMUM RATING")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.top, 24)
                    
                    FlowLayout(spacing: 12) {
                        
                        ForEach(ratings, id: \.self) { rating in
                            
                            FilterChip(
                                title: rating,
                                isSelected: currentRating == rating
                            ) {
                                currentRating = rating
                            }
                        }
                    }
                    .padding(.top, 16)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color(.systemGray4))
                        .padding(.top, 24)
                    
                    // MARK: Open Now
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("Open Now")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(.primary)
                            
                            Text("Show only currently open places")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $currentOpenNow)
                            .labelsHidden()
                            .tint(.orange)
                    }
                    .padding(.top, 32)
                    .padding(.trailing, 24)
                    
                    // MARK: Apply
                    
                    Button {
                        
                        onApply(
                            currentDistance,
                            currentRating,
                            currentOpenNow
                        )
                        
                    } label: {
                        
                        Text("Apply Filters")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 360)
                            .frame(height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.orange)
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 36)
                    .padding(.bottom, 20)
                }
            }
        }
        .padding(.horizontal, 21)
        .padding(.top, 8)
        .background(Color(.systemBackground))
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
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(
                    isSelected
                    ? .white
                    : .primary
                )
                .padding(.horizontal, 14)
                .frame(height: 36)
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

#Preview {
    FilterSheet(
        selectedDistance: "5 km",
        selectedRating: "Any",
        openNow: false,
        onDismiss: {
            print("Dismiss")
        },
        onApply: { distance, rating, openNow in
            print("Distance:", distance)
            print("Rating:", rating)
            print("Open Now:", openNow)
        }
    )
    .frame(width: 393, height: 500)
    .clipShape(
        RoundedRectangle(cornerRadius: 28)
    )
}
