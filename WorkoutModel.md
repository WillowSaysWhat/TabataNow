# Workout Model

Table of Contents

- [Workout Model](#workout-model)
  - [WorkoutModel](#workoutmodel)


## WorkoutModel

The workout model uses SwiftData to store the user's tabata workouts locally on their phones. This prevents the need for internet connection and authentification.

Each Tabata workout has a name, the duration of each exercise period and rest period. The length of the workout will be calculated using these periods and the amount of rounds in the session.

```swift
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
    
    init(name: String, workdur: Int, restdur: Int, rounds: Int, createdAt: Date = .now, lastUsed: Date? = nil) {
        
        self.id = UUID()
        
        self.name = name
        self.workoutDuration = workdur
        self.restDuration = restdur
        self.rounds = rounds
        self.createdAt = createdAt
        self.lastUsed = lastUsed ?? createdAt // if nil use created date.
        
    }
    
}
```