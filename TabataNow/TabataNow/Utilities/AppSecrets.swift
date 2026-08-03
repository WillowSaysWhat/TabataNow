//
//  AppSecrets.swift
//  TabataNow
//

import Foundation

enum AppSecrets {
    static var openAIAPIKey: String? {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "OpenAIAPIKey") as? String else {
            return nil
        }
        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false, trimmed != "your-key-here" else {
            print("OpenAIAPIKey present:", Bundle.main.object(forInfoDictionaryKey: "OpenAIAPIKey") != nil)
            return nil
        }
        return trimmed
    }
}
