//
//  PlaceInfo.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct PlaceInfo: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {

        HStack(alignment: .top, spacing: 16) {

            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.orange)
                .padding(.top, 11)

            VStack(alignment: .leading, spacing: 5) {

                Text(title)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)

                Text(value)
                    .font(.system(size: 16))
                    .foregroundStyle(.primary)
            }

            Spacer()
        }
    }
}
