import SwiftUI

/// Reusable Medal icon used for achievements / levels
struct MedalView: View {

    enum Style {
        case filled
        case outlined
    }

    var isActive: Bool
    var size: CGFloat = 24
    var style: Style = .filled

    var activeColor: Color = .green
    var inactiveColor: Color = .white.opacity(0.12)

    /// Optional glow for active medals
    var glow: Bool = false

    var body: some View {
        ZStack {
            Image(systemName: "rosette")
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(isActive ? activeColor : inactiveColor)
                .opacity(isActive ? 1.0 : 0.9)

            if glow && isActive {
                Image(systemName: "rosette")
                    .font(.system(size: size, weight: .semibold))
                    .foregroundStyle(activeColor)
                    .blur(radius: size * 0.35)
                    .opacity(0.6)
            }
        }
        .accessibilityElement()
        .accessibilityLabel(isActive ? "Unlocked medal" : "Locked medal")
    }
}

