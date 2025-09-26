//
//  EditSessionViewModel.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import Foundation
import SwiftData

@MainActor
final class EditSessionViewModel: ObservableObject {
    @Published var name: String
    @Published var descriptionText: String
    @Published var restTime: String
    @Published var exerciseTime: String
    @Published var repetitions: String

    @Published var validationMessage: String? = nil

    private let session: TabataSession

    init(session: TabataSession) {
        self.session = session
        self.name = session.name
        self.descriptionText = session.sessionDescription
        self.restTime = String(session.restTime)
        self.exerciseTime = String(session.exerciseTime)
        self.repetitions = String(session.repetitions)
    }

    func validate() -> Bool {
        validationMessage = nil
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.isEmpty == false else { validationMessage = "Name cannot be empty."; return false }
        guard let rest = Int(restTime), rest > 0 else { validationMessage = "Rest time must be a number > 0."; return false }
        guard let exercise = Int(exerciseTime), exercise > 0 else { validationMessage = "Exercise time must be a number > 0."; return false }
        guard let reps = Int(repetitions), reps > 0 else { validationMessage = "Repetitions must be a number > 0."; return false }
        return true
    }

    func save(in context: ModelContext) throws {
        guard validate(),
              let rest = Int(restTime),
              let exercise = Int(exerciseTime),
              let reps = Int(repetitions) else { return }

        session.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        session.sessionDescription = descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)
        session.restTime = rest
        session.exerciseTime = exercise
        session.repetitions = reps
        session.lastUpdatedAt = .now

        try context.save()
    }
}


