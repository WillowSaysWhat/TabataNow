//
//  EditSessionView.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import SwiftUI
import SwiftData

struct EditSessionView: View {
    @Environment(\ .dismiss) private var dismiss
    @Environment(\ .modelContext) private var modelContext
    @StateObject private var viewModel: EditSessionViewModel

    init(session: TabataSession) {
        _viewModel = StateObject(wrappedValue: EditSessionViewModel(session: session))
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
        .navigationTitle("Edit Session")
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

    private func save() {
        do {
            try viewModel.save(in: modelContext)
            dismiss()
        } catch {
            viewModel.validationMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}

#Preview {
    let session = TabataSession(name: "Preview Session",
                                description: "Preview only",
                                restTime: 10,
                                exerciseTime: 20,
                                repetitions: 8)
    return NavigationStack { EditSessionView(session: session) }
}


