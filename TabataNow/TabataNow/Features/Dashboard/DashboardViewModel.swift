//
//  DashboardViewModel.swift
//  TabataNow
//
//  Created by Huw Williams on 16/12/2025.
//

import Foundation
import SwiftData

struct DayHistoryStatus: Identifiable {
    let id: Date
    let title: String
    let isInactive: Bool
    let didStrength: Bool
    let didFlame: Bool
    let didMedal: Bool
    let didCheck: Bool
}

@MainActor
final class DashboardViewModel: ObservableObject {

    func historyRows(for workouts: [CompletedWorkout]) -> [DayHistoryStatus] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let minutesGoal = ProfileUserDefaults.dailyMinutesGoal
        let workoutsGoal = ProfileUserDefaults.dailyWorkoutsGoal

        return [2, 1, 0].compactMap { daysAgo in
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else {
                return nil
            }

            let dayWorkouts = workouts.filter { calendar.isDate($0.completedAt, inSameDayAs: date) }
            let workoutCount = dayWorkouts.count
            let totalMinutes = dayWorkouts.reduce(0) { $0 + ($1.durationSeconds / 60) }

            let didStrength = workoutCount > 0
            let didFlame = totalMinutes >= minutesGoal
            let didMedal = workoutCount >= workoutsGoal
            let didCheck = didFlame && didMedal

            let title: String
            let isInactive: Bool
            switch daysAgo {
            case 0:
                title = "TODAY"
                isInactive = true
            case 1:
                title = "Yesterday"
                isInactive = false
            default:
                title = "day before"
                isInactive = false
            }

            return DayHistoryStatus(
                id: date,
                title: title,
                isInactive: isInactive,
                didStrength: didStrength,
                didFlame: didFlame,
                didMedal: didMedal,
                didCheck: didCheck
            )
        }
    }
}
