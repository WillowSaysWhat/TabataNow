//
//  WorkoutGenerationTests.swift
//  TabataNowTests
//

import XCTest
@testable import TabataNow

final class WorkoutGenerationTests: XCTestCase {
    func testPromptDescriptionIncludesAllSelectedPreferences() {
        let preferences = WorkoutGenerationPreferences(
            location: .gym,
            resistanceType: .weighted,
            weightEquipment: .kettlebells,
            includeBurpees: true,
            includeRunning: true,
            includeCycling: false,
            focus: .targeted,
            targetBodyPart: .legs
        )

        let prompt = preferences.promptDescription()

        XCTAssertTrue(prompt.contains("Gym"))
        XCTAssertTrue(prompt.contains("Weighted"))
        XCTAssertTrue(prompt.contains("Kettlebells"))
        XCTAssertTrue(prompt.contains("Targeted"))
        XCTAssertTrue(prompt.contains("Legs"))
        XCTAssertTrue(prompt.contains("burpees"))
        XCTAssertTrue(prompt.contains("running"))
        XCTAssertFalse(prompt.contains("cycling"))
    }

    func testPromptDescriptionUsesInPlaceVariantsForHomeWorkouts() {
        let preferences = WorkoutGenerationPreferences(location: .home)
        let prompt = preferences.promptDescription()

        XCTAssertTrue(prompt.contains("in-place variants"))
    }

    func testDecodeGeneratedTabataSessionDTO() throws {
        let json = """
        {
            "name": "Morning Burn",
            "description": "• Jump squats\\n• Push-ups",
            "exerciseTime": 20,
            "restTime": 10,
            "repetitions": 8
        }
        """

        let dto = try JSONDecoder().decode(
            GeneratedTabataSessionDTO.self,
            from: Data(json.utf8)
        )

        XCTAssertEqual(dto.name, "Morning Burn")
        XCTAssertEqual(dto.exerciseTime, 20)
        XCTAssertEqual(dto.restTime, 10)
        XCTAssertEqual(dto.repetitions, 8)
    }

    func testGeneratedTabataSessionDTOMapsToTabataSession() {
        let dto = GeneratedTabataSessionDTO(
            name: "Core Blast",
            description: "• Plank\n• Crunches",
            exerciseTime: 30,
            restTime: 15,
            repetitions: 6
        )

        let session = dto.toTabataSession()

        XCTAssertEqual(session.name, "Core Blast")
        XCTAssertEqual(session.sessionDescription, "• Plank\n• Crunches")
        XCTAssertEqual(session.exerciseTime, 30)
        XCTAssertEqual(session.restTime, 15)
        XCTAssertEqual(session.repetitions, 6)
    }
}
