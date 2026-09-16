//
//  LocationPill.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct LocationPill: View {
    let location: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 10, weight: .semibold))
                }

                Text(
                    isLoading
                    ? "Updating location..."
                    : location
                )
                .font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(.gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(.plain)
    }
}
