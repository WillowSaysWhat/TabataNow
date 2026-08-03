//
//  GenerateSessionView.swift
//  TabataNow
//

import SwiftUI

struct GenerateSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: GenerateSessionViewModel

    @MainActor
    init(openAIService: OpenAIServiceProtocol = OpenAIService()) {
        _viewModel = StateObject(wrappedValue: GenerateSessionViewModel(openAIService: openAIService))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Location") {
                    Picker("Location", selection: $viewModel.preferences.location) {
                        ForEach(WorkoutLocation.allCases) { location in
                            Text(location.label).tag(location)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }

                Section("Resistance") {
                    Picker("Resistance", selection: $viewModel.preferences.resistanceType) {
                        ForEach(ResistanceType.allCases) { type in
                            Text(type.label).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }

                if viewModel.preferences.resistanceType == .weighted {
                    Section("Equipment") {
                        Picker("Equipment", selection: $viewModel.preferences.weightEquipment) {
                            ForEach(WeightEquipment.allCases) { equipment in
                                Text(equipment.label).tag(equipment)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                }

                Section("Include") {
                    Toggle("Burpees", isOn: $viewModel.preferences.includeBurpees)
                    Toggle("Running", isOn: $viewModel.preferences.includeRunning)
                    Toggle("Cycling", isOn: $viewModel.preferences.includeCycling)
                }

                Section("Focus") {
                    Picker("Focus", selection: $viewModel.preferences.focus) {
                        ForEach(WorkoutFocus.allCases) { focus in
                            Text(focus.label).tag(focus)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()

                    if viewModel.preferences.focus == .targeted {
                        Picker("Body Part", selection: $viewModel.preferences.targetBodyPart) {
                            ForEach(BodyPart.allCases) { part in
                                Text(part.label).tag(part)
                            }
                        }
                    }
                }

                if let message = viewModel.errorMessage {
                    Section {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Generate Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Generate") {
                        Task { await viewModel.generate() }
                    }
                    .disabled(viewModel.canGenerate == false)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.2).ignoresSafeArea()
                        ProgressView("Generating…")
                            .padding()
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isPresentingPreview) {
                if let generated = viewModel.generatedSession {
                    NewSessionView(
                        generated: generated,
                        navigationTitle: "Review Workout",
                        onRegenerate: { viewModel.regenerate() },
                        onSaveComplete: { dismiss() }
                    )
                }
            }
        }
    }
}

#Preview {
    GenerateSessionView(openAIService: MockOpenAIService())
}
