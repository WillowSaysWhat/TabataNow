//
//  WorkoutModel.swift
//  TabataNow
//
//  Created by Huw Williams on 08/09/2025.
//

import Foundation
import SwiftData

@Model
class WorkoutModel{
    
    @Attribute(.unique) var id: UUID
    
    var name: String
    var workoutDuration: Int
    var restDuration: Int
    var rounds: Int
    var createdAt: Date
    var lastUsed: Date
    var timesUsed: Int
    
    init(name: String, workdur: Int, restdur: Int, rounds: Int, createdAt: Date = .now, lastUsed: Date? = nil) {
        
        self.id = UUID()
        
        self.name = name
        self.workoutDuration = workdur
        self.restDuration = restdur
        self.rounds = rounds
        self.createdAt = createdAt
        self.lastUsed = lastUsed ?? createdAt // if nil use created date.
        self.timesUsed = 0
        
    }
    
}
