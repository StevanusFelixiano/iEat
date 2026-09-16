//
//  StatusBadge.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import SwiftUI

struct StatusBadge: View {
    let openingHours: String?

    private var isOpen: Bool {
        guard let openingHours else {
            return true
        }

        let times = openingHours
            .replacingOccurrences(of: "Daily ", with: "")
            .components(separatedBy: "–")

        guard times.count == 2 else {
            return true
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard
            let openingTime = formatter.date(
                from: times[0].trimmingCharacters(in: .whitespaces)
            ),
            let closingTime = formatter.date(
                from: times[1].trimmingCharacters(in: .whitespaces)
            )
        else {
            return true
        }

        let calendar = Calendar.current
        let now = Date()

        let currentMinutes =
            calendar.component(.hour, from: now) * 60
            + calendar.component(.minute, from: now)

        let openingMinutes =
            calendar.component(.hour, from: openingTime) * 60
            + calendar.component(.minute, from: openingTime)

        let closingMinutes =
            calendar.component(.hour, from: closingTime) * 60
            + calendar.component(.minute, from: closingTime)

        return currentMinutes >= openingMinutes
            && currentMinutes < closingMinutes
    }

    private var closingText: String {
        guard let openingHours else {
            return ""
        }

        let times = openingHours
            .replacingOccurrences(of: "Daily ", with: "")
            .components(separatedBy: "–")

        guard times.count == 2 else {
            return ""
        }

        return times[1].trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        Text(
            openingHours == nil
            ? "Open · Hours unavailable"
            : isOpen
                ? "Open · Closes \(closingText)"
                : "Closed"
        )
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(.white)
        .padding(.horizontal, 17)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(isOpen ? Color.green : Color.red)
        )
    }
}
