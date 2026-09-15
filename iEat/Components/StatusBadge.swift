//
//  StatusBadge.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct StatusBadge: View {

    let closingTime: String

    var body: some View {
        Text("Open · \(closingTime)")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 17)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.green)
            )
    }
}
