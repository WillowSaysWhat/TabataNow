//
//  TabataNowApp.swift
//  TabataNow
//
//  Created by Huw Williams on 08/09/2025.
//

import SwiftUI
import SwiftData

@main
struct TabataNowApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: TabataSession.self)
    }
}
