//
//  NewSessionViewModel.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import Foundation
import SwiftData

@MainActor
final class NewSessionViewModel: ObservableObject {
    // Form fields
    @Published var name: String = ""
    @Published var descriptionText: String = ""
    @Published var restTime: String = "10" // seconds as text for TextField binding
    @Published var exerciseTime: String = "20"
    @Published var repetitions: String = "8"

    // Validation error message for display
    @Published var validationMessage: String? = nil

    init() {}

    init(from generated: GeneratedTabataSessionDTO) {
        name = generated.name
        descriptionText = generated.description
        exerciseTime = String(generated.exerciseTime)
        restTime = String(generated.restTime)
        repetitions = String(generated.repetitions)
    }

    func validate() -> Bool {
        validationMessage = nil

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.isEmpty == false else {
            validationMessage = "Name cannot be empty."
            return false
        }

        guard let rest = Int(restTime), rest > 0 else {
            validationMessage = "Rest time must be a number > 0."
            return false
        }

        guard let exercise = Int(exerciseTime), exercise > 0 else {
            validationMessage = "Exercise time must be a number > 0."
            return false
        }

        guard let reps = Int(repetitions), reps > 0 else {
            validationMessage = "Repetitions must be a number > 0."
            return false
        }

        // All good
        return true
    }

    func makeSession() -> TabataSession? {
        guard validate(),
              let rest = Int(restTime),
              let exercise = Int(exerciseTime),
              let reps = Int(repetitions)
        else { return nil }

        return TabataSession(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: descriptionText.trimmingCharacters(in: .whitespacesAndNewlines),
            restTime: rest,
            exerciseTime: exercise,
            repetitions: reps
        )
    }

    func save(in context: ModelContext) throws {
        guard let session = makeSession() else { return }
        context.insert(session)
        try context.save()
    }
}


