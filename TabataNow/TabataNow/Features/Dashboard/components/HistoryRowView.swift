//
//  HistoryRowView.swift
//  TabataNow
//
//  Created by Huw Williams on 16/12/2025.
//

import SwiftUI

/// A single row in the History card.
struct HistoryRowView: View {

    var title: String
    /// Dims the row styling — used for TODAY while goals are still in progress.
    var isInactive: Bool

    /// At least one workout completed that day.
    var didStrength: Bool
    /// Daily minutes goal met.
    var didFlame: Bool
    /// Daily workouts goal met.
    var didMedal: Bool
    /// All daily goals met.
    var didCheck: Bool

    init(status: DayHistoryStatus) {
        title = status.title
        isInactive = status.isInactive
        didStrength = status.didStrength
        didFlame = status.didFlame
        didMedal = status.didMedal
        didCheck = status.didCheck
    }

    init(
        title: String,
        isInactive: Bool = false,
        didStrength: Bool,
        didFlame: Bool,
        didMedal: Bool,
        didCheck: Bool
    ) {
        self.title = title
        self.isInactive = isInactive
        self.didStrength = didStrength
        self.didFlame = didFlame
        self.didMedal = didMedal
        self.didCheck = didCheck
    }



    var body: some View {
        HStack(spacing: 18) {

            Text(title)
                .font(.system(size: title.uppercased() == "TODAY" ? 28 : 21,
                              weight: title.uppercased() == "TODAY" ? .heavy : .light))
                .foregroundStyle(Color.white.opacity(isInactive ? 0.55 : 0.75))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Spacer(minLength: 8)

            // Strength = workout done, Flame = minutes goal, Medal = workouts goal, Check = all goals
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
