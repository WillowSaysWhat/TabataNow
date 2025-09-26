//
//  TimerView.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import SwiftUI

struct TimerView: View {
    @Environment(\ .dismiss) private var dismiss
    @StateObject private var viewModel: TimerViewModel
    @State private var showAbandonConfirm: Bool = false

    init(exerciseTime: Int, restTime: Int, repetitions: Int) {
        _viewModel = StateObject(wrappedValue: TimerViewModel(exerciseTime: exerciseTime, restTime: restTime, repetitions: repetitions))
    }

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // Background ring
                Circle()
                    .stroke(lineWidth: 24)
                    .foregroundStyle(.quaternary)

                // Overall progress ring (outer)
                Circle()
                    .trim(from: 0, to: viewModel.overallProgress())
                    .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(.blue.opacity(0.4))
                    .animation(.linear(duration: 0.2), value: viewModel.overallProgress())

                // Phase progress ring (inner)
                Circle()
                    .inset(by: 14)
                    .trim(from: 0, to: viewModel.phaseProgress())
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(viewModel.currentPhase == .exercise ? .green : .orange)
                    .animation(.linear(duration: 0.2), value: viewModel.phaseProgress())

                VStack(spacing: 6) {
                    Text(viewModel.currentPhase == .exercise ? "GO" : "REST")
                        .font(.headline.smallCaps())
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.remainingSeconds)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("Rep \(viewModel.currentRepetition)/\(viewModel.repetitions)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 280)
            .padding(.horizontal, 24)

            HStack(spacing: 16) {
                Button {
                    viewModel.reset()
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }

                Spacer()

                Button {
                    viewModel.isRunning ? viewModel.pause() : viewModel.start()
                } label: {
                    Label(viewModel.isRunning ? "Pause" : "Start",
                          systemImage: viewModel.isRunning ? "pause.fill" : "play.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Timer")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showAbandonConfirm = true
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
        .alert("Abandon session?", isPresented: $showAbandonConfirm) {
            Button("Abandon", role: .destructive) {
                viewModel.pause()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your progress will be lost.")
        }
        .onDisappear { viewModel.pause() }
    }
}

#Preview {
    NavigationStack {
        TimerView(exerciseTime: 20, restTime: 10, repetitions: 8)
    }
}


