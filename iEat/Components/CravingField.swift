//
//  CravingField.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct CravingField: View {

    @Binding var text: String
    let onSubmit: (FoodPreference) -> Void

    var body: some View {
        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)

            TextField(
                "Or type what you're craving...",
                text: $text
            )
            .font(.system(size: 16))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            Button {

                let customPreference = FoodPreference(
                    emoji: "🍽️",
                    name: text,
                    searchQuery: text
                )

                onSubmit(customPreference)

            } label: {

                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.orange)
            }
            .opacity(text.isEmpty ? 0 : 1)
            .frame(width: 22, height: 22)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray6))
        )
    }
}
