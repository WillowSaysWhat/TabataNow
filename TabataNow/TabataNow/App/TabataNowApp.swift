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
       
    

    
    init() {
        // This changes the colour of the tab to neon.
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black

        // Selected tab
        appearance.stackedLayoutAppearance.selected.iconColor = .neon
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.neon
        ]

        // Unselected tabs
        appearance.stackedLayoutAppearance.normal.iconColor =
            UIColor.white.withAlphaComponent(0.4)

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.4)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        NSLog("This is the console via NSLog")
        
    }
    
    var body: some Scene {
        WindowGroup {
            TABView()
                
        }
        .modelContainer(for: [TabataSession.self, CompletedWorkout.self])
        
    }
}



