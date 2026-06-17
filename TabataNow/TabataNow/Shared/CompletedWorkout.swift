//
//  CompletedWorkout.swift
//  TabataNow
//
//  Created by Cursor AI on 16/12/2025.
//

import Foundation
import SwiftData

/// A record of a completed Tabata workout session
@Model
final class CompletedWorkout {
    @Attribute(.unique) var id: UUID
    var completedAt: Date
    var durationSeconds: Int // Total duration of the workout
    var sessionName: String // Name of the session that was completed
    var exerciseTime: Int
    var restTime: Int
    var repetitions: Int

    init(
        id: UUID = UUID(),
        completedAt: Date = .now,
        durationSeconds: Int,
        sessionName: String,
        exerciseTime: Int,
        restTime: Int,
        repetitions: Int
    ) {
        self.id = id
        self.completedAt = completedAt
        self.durationSeconds = durationSeconds
        self.sessionName = sessionName
        self.exerciseTime = exerciseTime
        self.restTime = restTime
        self.repetitions = repetitions
    }
}



