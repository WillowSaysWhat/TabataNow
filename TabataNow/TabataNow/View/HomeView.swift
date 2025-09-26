//
//  HomeView.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import SwiftUI
import SwiftData

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isPresentingNewSession: Bool = false
}

struct HomeView: View {
    @Query(sort: \TabataSession.createdAt, order: .reverse) private var sessions: [TabataSession]
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            List {
                if sessions.isEmpty {
                    ContentUnavailableView("No Sessions",
                                            systemImage: "timer",
                                            description: Text("Create your first Tabata session"))
                } else {
                    ForEach(sessions) { session in
                        NavigationLink(value: session) {
                            SessionRow(session: session)
                        }
                    }
                }
            }
            .navigationTitle("Tabata Now")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.isPresentingNewSession = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("New Session")
                }
            }
            .navigationDestination(for: TabataSession.self) { session in
                SessionDetailView(session: session)
            }
            .sheet(isPresented: $viewModel.isPresentingNewSession) {
                NewSessionView()
            }
        }
    }
}

private struct SessionRow: View {
    let session: TabataSession

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.name)
                    .font(.headline)
                Text(session.sessionDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("Work: \(session.exerciseTime)s")
                    .font(.caption)
                Text("Rest: \(session.restTime)s")
                    .font(.caption)
                Text("x\(session.repetitions)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    // In-memory container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TabataSession.self, configurations: config)
    let context = ModelContext(container)
    context.insert(TabataSession(name: "Morning Burn", description: "Quick HIIT", restTime: 10, exerciseTime: 20, repetitions: 8))
    context.insert(TabataSession(name: "Evening Core", description: "Core focus", restTime: 15, exerciseTime: 30, repetitions: 6))

    return HomeView()
        .modelContainer(container)
}


