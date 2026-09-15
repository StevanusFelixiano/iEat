//
//  LocationPill.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct LocationPill: View {

    let location: String

    var body: some View {
        HStack(spacing: 8) {

            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.gray)

            Text(location)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color(.systemGray6))
        )
    }
}
