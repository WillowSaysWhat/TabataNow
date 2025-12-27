import SwiftUI

/// A reusable “Level Progress” bar inspired by your prototype:
/// - Left side shows filled (dark) portion
/// - Right side shows a highlighted label “XX% left” (or any text)
struct LevelProgressBar: View {
    /// 0.0 ... 1.0 (portion filled on the left)
    let progress: Double

    var height: CGFloat = 22
    var cornerRadius: CGFloat = 4
    var borderWidth: CGFloat = 3

    var trackColor: Color = .green // background
    var fillColor: Color = .black.opacity(0.68) // foreground
    var borderColor: Color = .green
    var labelBackground: Color = .green
    var labelForeground: Color = .black.opacity(0.75)

    /// If nil, no label pill is shown.
    var labelText: String? = "ERROR"

    /// Inner padding between outer rounded rect and fill/label
    var innerPadding: CGFloat = 6

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let p = min(max(progress, 0), 1)

            ZStack(alignment: .leading) {
                // Track + border
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(trackColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )

                // Filled portion (left)
                RoundedRectangle(cornerRadius: max(0, cornerRadius - 2))
                    .fill(fillColor)
                    .frame(width: max(0, (w - 2 * innerPadding) * p))
                    .padding(innerPadding)

                // Label pill (right)
                if let labelText {
                    HStack {
                        Spacer()
                        Text(labelText)
                            .font(.system(size: clamp(h * 0.40, min: 16, max: 22), weight: .medium))
                            .foregroundStyle(labelForeground)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .padding(.horizontal, 16)
                            .frame(height: h - (innerPadding * 2) + 2)
                            .background(labelBackground)
                            .clipShape(RoundedRectangle(cornerRadius: max(0, cornerRadius - 2)))
                            .padding(innerPadding - 1)
                    }
                }
            }
        }
        .frame(height: height)
        .accessibilityElement()
        .accessibilityLabel("Level progress")
        .accessibilityValue("\(Int(min(max(progress, 0), 1) * 100)) percent")
    }

    private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        Swift.max(min, Swift.min(max, value))
    }
}

#Preview {
    LevelProgressBar(progress: 0.5)
}
