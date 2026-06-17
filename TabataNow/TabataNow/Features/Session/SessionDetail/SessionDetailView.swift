//
//  SessionDetailView.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import SwiftUI
import SwiftData

struct SessionDetailView: View {
    let session: TabataSession

    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Name", value: session.name)
                LabeledContent("Description", value: session.sessionDescription)
            }
            Section("Timing") {
                LabeledContent("Exercise Time", value: "\(session.exerciseTime) sec")
                LabeledContent("Rest Time", value: "\(session.restTime) sec")
                LabeledContent("Repetitions", value: "\(session.repetitions)")
            }

            Section {
                NavigationLink {
                    TimerView(
                        exerciseTime: session.exerciseTime,
                        restTime: session.restTime,
                        repetitions: session.repetitions,
                        sessionName: session.name
                    )
                } label: {
                    Label("Tabata Now?", systemImage: "play.circle.fill")
                }
            }
        }
        .navigationTitle(session.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    EditSessionView(session: session)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}

#Preview {
    let session = TabataSession(name: "Preview Session",
                                description: "Preview only",
                                restTime: 10,
                                exerciseTime: 20,
                                repetitions: 8)
    return NavigationStack { SessionDetailView(session: session) }
}


