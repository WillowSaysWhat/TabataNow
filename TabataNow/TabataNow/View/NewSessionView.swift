//
//  NewSessionView.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import SwiftUI
import SwiftData

struct NewSessionView: View {
    @Environment(\ .dismiss) private var dismiss
    @Environment(\ .modelContext) private var modelContext
    @StateObject private var viewModel = NewSessionViewModel()

    var body: some View {
        NavigationStack {
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
            .navigationTitle("New Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .bold()
                }
            }
        }
    }

    private func save() {
        do {
            try viewModel.save(in: modelContext)
            dismiss()
        } catch {
            // Simple inline error. In a larger app, surface this via an error handler.
            viewModel.validationMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TabataSession.self, configurations: config)
    return NewSessionView()
        .modelContainer(container)
}


