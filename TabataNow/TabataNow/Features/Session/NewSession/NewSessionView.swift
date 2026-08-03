//
//  NewSessionView.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import SwiftUI
import SwiftData

struct NewSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: NewSessionViewModel

    private let navigationTitle: String
    private let onRegenerate: (() -> Void)?
    private let onSaveComplete: (() -> Void)?

    @MainActor
    init(
        navigationTitle: String = "New Session",
        onRegenerate: (() -> Void)? = nil,
        onSaveComplete: (() -> Void)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: NewSessionViewModel())
        self.navigationTitle = navigationTitle
        self.onRegenerate = onRegenerate
        self.onSaveComplete = onSaveComplete
    }

    @MainActor
    init(
        generated: GeneratedTabataSessionDTO,
        navigationTitle: String = "Review Workout",
        onRegenerate: (() -> Void)? = nil,
        onSaveComplete: (() -> Void)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: NewSessionViewModel(from: generated))
        self.navigationTitle = navigationTitle
        self.onRegenerate = onRegenerate
        self.onSaveComplete = onSaveComplete
    }

    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $viewModel.name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                TextField("Description", text: $viewModel.descriptionText, axis: .vertical)
                    .lineLimit(2...4)
            }

            Section("Timing (seconds)") {
                TextField("Exercise time", text: $viewModel.exerciseTime)
                    .keyboardType(.numberPad)
                TextField("Rest time", text: $viewModel.restTime)
                    .keyboardType(.numberPad)
            }

            Section("Repetitions") {
                TextField("Repetitions", text: $viewModel.repetitions)
                    .keyboardType(.numberPad)
            }

            if let message = viewModel.validationMessage {
                Section {
                    Text(message)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let onRegenerate {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Regenerate") { onRegenerate() }
                }
            } else {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .bold()
            }
        }
    }

    private func save() {
        do {
            try viewModel.save(in: modelContext)
            onSaveComplete?()
            dismiss()
        } catch {
            viewModel.validationMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TabataSession.self, configurations: config)
    return NavigationStack {
        NewSessionView()
    }
    .modelContainer(container)
}
