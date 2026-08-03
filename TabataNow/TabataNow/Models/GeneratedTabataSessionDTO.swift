//
//  GeneratedTabataSessionDTO.swift
//  TabataNow
//

import Foundation

struct GeneratedTabataSessionDTO: Codable, Equatable {
    let name: String
    let description: String
    let exerciseTime: Int
    let restTime: Int
    let repetitions: Int

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case exerciseTime
        case restTime
        case repetitions
    }

    func toTabataSession() -> TabataSession {
        TabataSession(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            restTime: restTime,
            exerciseTime: exerciseTime,
            repetitions: repetitions
        )
    }
}

extension GeneratedTabataSessionDTO {
    static let jsonSchema: [String: Any] = [
        "type": "object",
        "properties": [
            "name": [
                "type": "string",
                "description": "Short catchy workout name"
            ],
            "description": [
                "type": "string",
                "description": "Bullet-list of exercises for each work interval, with brief coaching notes"
            ],
            "exerciseTime": [
                "type": "integer",
                "description": "Work interval duration in seconds (15-60)"
            ],
            "restTime": [
                "type": "integer",
                "description": "Rest interval duration in seconds (5-30)"
            ],
            "repetitions": [
                "type": "integer",
                "description": "Number of Tabata rounds (4-12)"
            ]
        ],
        "required": ["name", "description", "exerciseTime", "restTime", "repetitions"],
        "additionalProperties": false
    ]
}
