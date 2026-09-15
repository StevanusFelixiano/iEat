//
//  CravingCard.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct CravingCard: View {

    let emoji: String
    let title: String
    let action: () -> Void

    var body: some View {

        Button {
            action()
        } label: {

            VStack(alignment: .leading, spacing: 0) {

                Text(emoji)
                    .font(.system(size: 36))
                    .frame(height: 65)
                    .padding(.bottom, -10)

                Spacer()

                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.primary)
                    .padding(.bottom, 15)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: .black.opacity(0.07),
                        radius: 12,
                        x: 0,
                        y: 5
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
