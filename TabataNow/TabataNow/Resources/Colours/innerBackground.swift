// Colors.swift

import SwiftUI
import UIKit

extension Color {
    /// Dark inner card/background color used in History rows, cards, etc.
    static let innerBackground = Color(
        red: 18/255,
        green: 33/255,
        blue: 43/255
    )
}

extension UIColor {
    /// UIKit equivalent of `Color.innerBackground`
    static let innerBackground = UIColor(
        red: 18/255,
        green: 33/255,
        blue: 43/255,
        alpha: 1.0
    )
}
