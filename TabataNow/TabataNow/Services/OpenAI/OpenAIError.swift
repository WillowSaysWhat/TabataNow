//
//  OpenAIError.swift
//  TabataNow
//

import Foundation

enum OpenAIError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case decodingFailed
    case network(underlying: Error)
    case apiError(message: String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            "OpenAI API key is not configured. Copy Config/Secrets.example.xcconfig to Config/Secrets.xcconfig and add your key."
        case .invalidResponse:
            "Received an invalid response from OpenAI."
        case .decodingFailed:
            "Could not decode the generated workout."
        case .network(let underlying):
            "Network error: \(underlying.localizedDescription)"
        case .apiError(let message):
            message
        }
    }
}
