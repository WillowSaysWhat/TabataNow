//
//  HistoryRowView.swift
//  TabataNow
//
//  Created by Huw Williams on 16/12/2025.
//

import SwiftUI

/// A single row in the History card (hard-coded placeholders you can replace later).
struct HistoryRowView: View {

    // MARK: - Placeholders (replace later)
    var title: String = "Yesterday"
    /// "inactive" dims the row like TODAY in your prototype.
    var isInactive: Bool = false

    /// Toggle these to represent completion states later
    var didStrength: Bool = true
    var didFlame: Bool = true
    var didMedal: Bool = false
    var didCheck: Bool = true



    var body: some View {
        HStack(spacing: 18) {

            Text(title)
                .font(.system(size: title.uppercased() == "TODAY" ? 28 : 21,
                              weight: title.uppercased() == "TODAY" ? .heavy : .light))
                .foregroundStyle(Color.white.opacity(isInactive ? 0.55 : 0.75))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Spacer(minLength: 8)

            // Icons (hard-coded set you can map to real data later)
            icon(systemName: "figure.strengthtraining.traditional", isOn: didStrength, label: "Strength")
            icon(systemName: "flame.fill", isOn: didFlame, label: "Intensity")
            icon(systemName: "rosette", isOn: didMedal, label: "Medal")
            icon(systemName: "checkmark", isOn: didCheck, label: "Complete")
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.innerBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.08), lineWidth: 2)
                )
        )
        .opacity(isInactive ? 0.85 : 1.0)
    }

    private func icon(systemName: String, isOn: Bool, label: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(isOn ? .neon : Color.white.opacity(0.12))
            .frame(width: 24)
            .accessibilityLabel(label)
    }
}


#Preview {
    VStack(spacing: 14) {
        HistoryRowView(title: "day before", didStrength: true, didFlame: false, didMedal: false, didCheck: false)
        HistoryRowView(title: "Yesterday", didStrength: true, didFlame: true, didMedal: true, didCheck: true)
        HistoryRowView(title: "TODAY", isInactive: true, didStrength: false, didFlame: false, didMedal: false, didCheck: false)
    }
    .padding()
    .preferredColorScheme(.dark)
    .background(Color.black)
}
