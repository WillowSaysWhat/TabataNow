import SwiftUI

/// A reusable placeholder / empty-state view
/// showing a large SF Symbol and a title.
struct PlaceholderView: View {

    let systemImage: String
    let title: String

    var subtitle: String? = nil

    var iconSize: CGFloat = 64
    var titleFont: Font = .title2
    var subtitleFont: Font = .body

    var iconColor: Color = .secondary
    var textColor: Color = .secondary

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: iconSize, weight: .regular))
                .foregroundStyle(iconColor)
                .symbolRenderingMode(.hierarchical)

            Text(title)
                .font(titleFont)
                .fontWeight(.semibold)
                .foregroundStyle(textColor)

            if let subtitle {
                Text(subtitle)
                    .font(subtitleFont)
                    .foregroundStyle(textColor.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}
