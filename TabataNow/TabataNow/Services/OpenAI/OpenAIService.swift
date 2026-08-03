//
//  OpenAIService.swift
//  TabataNow
//

import Foundation

protocol OpenAIServiceProtocol {
    func generateSession(preferences: WorkoutGenerationPreferences) async throws -> GeneratedTabataSessionDTO
}

struct OpenAIService: OpenAIServiceProtocol {
    private let session: URLSession
    private let apiKeyProvider: () -> String?

    init(
        session: URLSession = .shared,
        apiKeyProvider: @escaping () -> String? = { AppSecrets.openAIAPIKey }
    ) {
        self.session = session
        self.apiKeyProvider = apiKeyProvider
    }

    func generateSession(preferences: WorkoutGenerationPreferences) async throws -> GeneratedTabataSessionDTO {
        guard let apiKey = apiKeyProvider() else {
            throw OpenAIError.missingAPIKey
        }

        let requestBody = try makeRequestBody(preferences: preferences)
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw OpenAIError.network(underlying: error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let message = parseAPIErrorMessage(from: data) ?? "OpenAI request failed with status \(httpResponse.statusCode)."
            throw OpenAIError.apiError(message: message)
        }

        return try decodeGeneratedSession(from: data)
    }

    private func makeRequestBody(preferences: WorkoutGenerationPreferences) throws -> Data {
        let schema = GeneratedTabataSessionDTO.jsonSchema
        let responseFormat: [String: Any] = [
            "type": "json_schema",
            "json_schema": [
                "name": "tabata_session",
                "strict": true,
                "schema": schema
            ]
        ]

        let systemPrompt = """
        You are an expert Tabata HIIT coach. Generate one Tabata workout session as JSON.
        Use classic Tabata timing unless the workout clearly needs different intervals.
        The description must list the exercises performed during each work interval as a concise bullet list.
        Respect all user constraints. Keep exerciseTime between 15 and 60 seconds, restTime between 5 and 30 seconds, and repetitions between 4 and 12.
        """

        let userPrompt = """
        Create a Tabata workout with these preferences:
        \(preferences.promptDescription())
        """

        let payload: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "response_format": responseFormat
        ]

        return try JSONSerialization.data(withJSONObject: payload)
    }

    private func decodeGeneratedSession(from data: Data) throws -> GeneratedTabataSessionDTO {
        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let choices = json["choices"] as? [[String: Any]],
            let firstChoice = choices.first,
            let message = firstChoice["message"] as? [String: Any],
            let content = message["content"] as? String,
            let contentData = content.data(using: .utf8)
        else {
            throw OpenAIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(GeneratedTabataSessionDTO.self, from: contentData)
        } catch {
            throw OpenAIError.decodingFailed
        }
    }

    private func parseAPIErrorMessage(from data: Data) -> String? {
        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let error = json["error"] as? [String: Any],
            let message = error["message"] as? String
        else {
            return nil
        }
        return message
    }
}

struct MockOpenAIService: OpenAIServiceProtocol {
    var result: Result<GeneratedTabataSessionDTO, Error> = .success(
        GeneratedTabataSessionDTO(
            name: "Home Core Burn",
            description: "• Mountain climbers\n• Plank jacks\n• Bicycle crunches\n• Russian twists",
            exerciseTime: 20,
            restTime: 10,
            repetitions: 8
        )
    )

    func generateSession(preferences: WorkoutGenerationPreferences) async throws -> GeneratedTabataSessionDTO {
        switch result {
        case .success(let session):
            return session
        case .failure(let error):
            throw error
        }
    }
}
