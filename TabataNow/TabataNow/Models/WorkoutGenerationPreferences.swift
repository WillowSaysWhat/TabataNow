//
//  WorkoutGenerationPreferences.swift
//  TabataNow
//

import Foundation

enum WorkoutLocation: String, CaseIterable, Identifiable, Codable {
    case gym
    case home

    var id: String { rawValue }

    var label: String {
        switch self {
        case .gym: "Gym"
        case .home: "At Home"
        }
    }
}

enum ResistanceType: String, CaseIterable, Identifiable, Codable {
    case weighted
    case bodyweight

    var id: String { rawValue }

    var label: String {
        switch self {
        case .weighted: "Weighted"
        case .bodyweight: "Bodyweight"
        }
    }
}

enum WeightEquipment: String, CaseIterable, Identifiable, Codable {
    case dumbbells
    case kettlebells

    var id: String { rawValue }

    var label: String {
        switch self {
        case .dumbbells: "Dumbbells"
        case .kettlebells: "Kettlebells"
        }
    }
}

enum WorkoutFocus: String, CaseIterable, Identifiable, Codable {
    case fullBody
    case targeted

    var id: String { rawValue }

    var label: String {
        switch self {
        case .fullBody: "Full Body"
        case .targeted: "Targeted"
        }
    }
}

enum BodyPart: String, CaseIterable, Identifiable, Codable {
    case chest
    case back
    case legs
    case arms
    case core
    case shoulders

    var id: String { rawValue }

    var label: String {
        rawValue.capitalized
    }
}

struct WorkoutGenerationPreferences: Equatable {
    var location: WorkoutLocation = .home
    var resistanceType: ResistanceType = .bodyweight
    var weightEquipment: WeightEquipment = .dumbbells
    var includeBurpees: Bool = false
    var includeRunning: Bool = false
    var includeCycling: Bool = false
    var focus: WorkoutFocus = .fullBody
    var targetBodyPart: BodyPart = .core

    func promptDescription() -> String {
        var parts: [String] = []

        parts.append("Location: \(location.label)")
        parts.append("Resistance: \(resistanceType.label)")

        if resistanceType == .weighted {
            parts.append("Equipment: \(weightEquipment.label)")
        }

        parts.append("Focus: \(focus.label)")
        if focus == .targeted {
            parts.append("Target body part: \(targetBodyPart.label)")
        }

        var includes: [String] = []
        if includeBurpees { includes.append("burpees") }
        if includeRunning { includes.append("running") }
        if includeCycling { includes.append("cycling") }

        if includes.isEmpty {
            parts.append("Do not include burpees, running, or cycling unless suitable for the workout style.")
        } else {
            parts.append("Must include: \(includes.joined(separator: ", "))")
        }

        if location == .home {
            parts.append("Use in-place variants for running and cycling when needed (e.g. high knees, sprint in place, air bike).")
        }

        return parts.joined(separator: "\n")
    }
}
