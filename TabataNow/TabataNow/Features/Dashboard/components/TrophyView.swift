import SwiftUI

/// Trophy icon used for level progress milestones.
struct TrophyView: View {

    var isActive: Bool
    var size: CGFloat = 20

    private let activeColor = Color(red: 0.62, green: 0.94, blue: 0.68)
    private let inactiveColor = Color.white.opacity(0.12)

    var body: some View {
        Image(systemName: "trophy.fill")
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(isActive ? activeColor : inactiveColor)
            .accessibilityLabel(isActive ? "Unlocked trophy" : "Locked trophy")
    }
}

#Preview {
    HStack(spacing: 8) {
        TrophyView(isActive: true)
        TrophyView(isActive: false)
    }
    .padding()
    .preferredColorScheme(.dark)
    .background(Color.black)
}
