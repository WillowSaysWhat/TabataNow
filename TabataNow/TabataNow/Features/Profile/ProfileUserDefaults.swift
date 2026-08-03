//
//  ProfileUserDefaults.swift
//  TabataNow
//
//  Created by Huw Williams on 16/12/2025.
//

import Foundation

struct ProfileUserDefaults {
    
    @Default(key: "hasCompletedOnboarding", defaultValue: false) static var hasCompletedOnboarding: Bool
    
    // Daily Goals
    @Default(key: "DailyMinutesGoal", defaultValue: 10) static var dailyMinutesGoal: Int
    
    @Default(key: "DailyWorkoutsGoal", defaultValue: 2) static var dailyWorkoutsGoal: Int

    // Weekly Goals
    @Default(key: "WeeklyMinutesGoal", defaultValue: 60) static var weeklyMinutesGoal: Int

    @Default(key: "WeeklyWorkoutsGoal", defaultValue: 10) static var weeklyWorkoutsGoal: Int
    
    // Stats Tracking
    @Default(key: "CurrentStreak", defaultValue: 0) static var currentStreak: Int
    
    @Default(key: "BestPeriodStreak", defaultValue: 0) static var bestPeriodStreak: Int
    
    @Default(key: "LastWorkoutDate", defaultValue: nil) static var lastWorkoutDate: Date?
    
    @Default(key: "TotalAwards", defaultValue: 0) static var totalAwards: Int
}
