//
//  DashboardUserDefaults.swift
//  TabataNow
//
//  Created by Huw Williams on 17/06/2026.
//

import Foundation

struct MedalUserDefaults {
    // User Default vars for the small medals above the progress bar.
    @Default(key: "hasCompletedMedal1", defaultValue: false) static var hasCompletedMedal1: Bool
    @Default(key: "hasCompletedMedal2", defaultValue: false) static var hasCompletedMedal2: Bool
    @Default(key: "hasCompletedMedal3", defaultValue: false) static var hasCompletedMedal3: Bool
    @Default(key: "hasCompletedMedal4", defaultValue: false) static var hasCompletedMedal4: Bool
}

