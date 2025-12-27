//
//  ActivityRing.swift
//  TabataNow
//
//  Created by Huw Williams on 15/12/2025.
//

import SwiftUI

/// Reusable "Activity Ring" style progress view.
struct ActivityRing<Center: View>: View {
    
    let progress: Double              // 0.0 ... 1.0
    var lineWidth: CGFloat = 22
    var trackColor: Color = .white.opacity(0.12)
    var progressColor: Color = .green
    var startAngle: Angle = .degrees(-90)
    var showsEndCap: Bool = false     // rounded cap dot at the end
    
    @ViewBuilder var center: () -> Center // centre text.

    init(
        progress: Double,
        lineWidth: CGFloat = 22,
        trackColor: Color = .white.opacity(0.12),
        progressColor: Color = .green,
        startAngle: Angle = .degrees(-90),
        showsEndCap: Bool = false,
        @ViewBuilder center: @escaping () -> Center = { EmptyView() as! Center }
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.startAngle = startAngle
        self.showsEndCap = showsEndCap
        self.center = center
    }

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let p = min(max(progress, 0), 1)

            ZStack {
                // Track
                Circle()
                    .stroke(trackColor, lineWidth: lineWidth)

                // Progress
                Circle()
                    .trim(from: 0, to: p)
                    .stroke(
                        progressColor,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(startAngle)
                    .animation(.easeInOut(duration: 3), value: p)

                // Optional end "cap" dot
                if showsEndCap && p > 0 {
                    Circle()
                        .fill(progressColor)
                        .frame(width: lineWidth, height: lineWidth)
                        .offset(y: -size / 2)
                        .rotationEffect(startAngle + .degrees(360 * p))
                        .animation(.easeInOut(duration: 3), value: p)
                }

                // Center content
                center()
                    .frame(width: size, height: size)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement()
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(min(max(progress, 0), 1) * 100)) percent")
    }
}

#Preview {
    ActivityRing(progress: 0.7) {
        Text("Placeholder")
    }
}
