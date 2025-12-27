//
//  ProfileViewModel.swift
//  TabataNow
//
//  Created by Cursor AI on 16/12/2025.
//

import Foundation
import SwiftData

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var dailyMinutes: Int = 0
    @Published var dailyWorkouts: Int = 0
    @Published var weeklyMinutes: Int = 0
    @Published var weeklyWorkouts: Int = 0
    @Published var currentStreak: Int = 0
    @Published var bestPeriodStreak: Int = 0
    @Published var totalAwards: Int = 0
    @Published var overallProgress: Double = 0.0
    
    private var modelContext: ModelContext?
    
    private init(modelContext: ModelContext?) {
        self.modelContext = modelContext
        if modelContext != nil {
            loadStats()
        }
    }
    
    static func createPlaceholder() -> ProfileViewModel {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: CompletedWorkout.self, configurations: config)
        let tempContext = ModelContext(container)
        return ProfileViewModel(modelContext: tempContext)
    }
    
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
    }
    
    func loadStats() {
        guard let modelContext = modelContext else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Get start of today and this week
        let startOfToday = calendar.startOfDay(for: now)
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            return
        }
        
        // Fetch all completed workouts
        let descriptor = FetchDescriptor<CompletedWorkout>(
            sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
        )
        
        guard let allWorkouts = try? modelContext.fetch(descriptor) else {
            return
        }
        
        // Calculate daily stats
        let todayWorkouts = allWorkouts.filter { workout in
            calendar.isDate(workout.completedAt, inSameDayAs: now)
        }
        dailyWorkouts = todayWorkouts.count
        dailyMinutes = todayWorkouts.reduce(0) { $0 + ($1.durationSeconds / 60) }
        
        // Calculate weekly stats
        let weekWorkouts = allWorkouts.filter { workout in
            workout.completedAt >= startOfWeek
        }
        weeklyWorkouts = weekWorkouts.count
        weeklyMinutes = weekWorkouts.reduce(0) { $0 + ($1.durationSeconds / 60) }
        
        // Calculate streak
        currentStreak = calculateCurrentStreak(workouts: allWorkouts, calendar: calendar)
        
        // Update best period streak if current is better
        let storedBest = ProfileUserDefaults.bestPeriodStreak
        if currentStreak > storedBest {
            ProfileUserDefaults.bestPeriodStreak = currentStreak
            bestPeriodStreak = currentStreak
        } else {
            bestPeriodStreak = storedBest
        }
        
        // Calculate total awards (achievements unlocked)
        totalAwards = calculateTotalAwards(workouts: allWorkouts)
        ProfileUserDefaults.totalAwards = totalAwards
        
        // Calculate overall progress (average of daily goals progress)
        let dailyMinutesGoal = ProfileUserDefaults.dailyMinutesGoal
        let dailyWorkoutsGoal = ProfileUserDefaults.dailyWorkoutsGoal
        let minutesProgress = dailyMinutesGoal > 0 ? min(1.0, Double(dailyMinutes) / Double(dailyMinutesGoal)) : 0.0
        let workoutsProgress = dailyWorkoutsGoal > 0 ? min(1.0, Double(dailyWorkouts) / Double(dailyWorkoutsGoal)) : 0.0
        overallProgress = (minutesProgress + workoutsProgress) / 2.0
    }
    
    private func calculateCurrentStreak(workouts: [CompletedWorkout], calendar: Calendar) -> Int {
        guard !workouts.isEmpty else { return 0 }
        
        // Get unique workout dates (one per day)
        let workoutDates = Set(workouts.map { calendar.startOfDay(for: $0.completedAt) })
        let sortedDates = workoutDates.sorted(by: >)
        
        guard let mostRecentDate = sortedDates.first else { return 0 }
        let today = calendar.startOfDay(for: Date())
        
        // If most recent workout is not today or yesterday, streak is broken
        let daysSinceLastWorkout = calendar.dateComponents([.day], from: mostRecentDate, to: today).day ?? 0
        if daysSinceLastWorkout > 1 {
            return 0
        }
        
        // Count consecutive days
        var streak = 0
        var currentDate = today
        
        for date in sortedDates {
            let daysDiff = calendar.dateComponents([.day], from: date, to: currentDate).day ?? 0
            if daysDiff == 0 || daysDiff == 1 {
                streak += 1
                currentDate = date
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func calculateTotalAwards(workouts: [CompletedWorkout]) -> Int {
        var awards = 0
        
        // Award for first workout
        if workouts.count >= 1 {
            awards += 1
        }
        
        // Award for 10 workouts
        if workouts.count >= 10 {
            awards += 1
        }
        
        // Award for 50 workouts
        if workouts.count >= 50 {
            awards += 1
        }
        
        // Award for 100 workouts
        if workouts.count >= 100 {
            awards += 1
        }
        
        // Award for 7-day streak
        if currentStreak >= 7 {
            awards += 1
        }
        
        // Award for 30-day streak
        if currentStreak >= 30 {
            awards += 1
        }
        
        return awards
    }
    
    var dailyMinutesProgress: Double {
        let goal = ProfileUserDefaults.dailyMinutesGoal
        guard goal > 0 else { return 0 }
        return min(1.0, Double(dailyMinutes) / Double(goal))
    }
    
    var dailyWorkoutsProgress: Double {
        let goal = ProfileUserDefaults.dailyWorkoutsGoal
        guard goal > 0 else { return 0 }
        return min(1.0, Double(dailyWorkouts) / Double(goal))
    }
}
