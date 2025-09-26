//
//  TabataSession.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import Foundation
import SwiftData

/// A persisted Tabata session configuration
@Model
final class TabataSession {
    @Attribute(.unique) var id: UUID
    var name: String
    var sessionDescription: String
    var restTime: Int
    var exerciseTime: Int
    var repetitions: Int
    var createdAt: Date
    var lastUpdatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        restTime: Int,
        exerciseTime: Int,
        repetitions: Int,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.sessionDescription = description
        self.restTime = restTime
        self.exerciseTime = exerciseTime
        self.repetitions = repetitions
        self.createdAt = createdAt
        self.lastUpdatedAt = createdAt
    }
}


