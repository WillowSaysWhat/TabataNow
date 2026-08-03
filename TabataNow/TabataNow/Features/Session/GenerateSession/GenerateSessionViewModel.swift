//
//  GenerateSessionViewModel.swift
//  TabataNow
//

import Foundation

@MainActor
final class GenerateSessionViewModel: ObservableObject {
    @Published var preferences = WorkoutGenerationPreferences()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var generatedSession: GeneratedTabataSessionDTO?
    @Published var isPresentingPreview = false

    private let openAIService: OpenAIServiceProtocol

    init(openAIService: OpenAIServiceProtocol = OpenAIService()) {
        self.openAIService = openAIService
    }

    var canGenerate: Bool {
        isLoading == false
    }

    func generate() async {
        guard canGenerate else { return }

        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let session = try await openAIService.generateSession(preferences: preferences)
            generatedSession = session
            isPresentingPreview = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func regenerate() {
        generatedSession = nil
        isPresentingPreview = false
        errorMessage = nil
    }
}
