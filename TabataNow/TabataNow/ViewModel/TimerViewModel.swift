//
//  TimerViewModel.swift
//  TabataNow
//
//  Created by Cursor AI on 26/09/2025.
//

import Foundation
import AVFoundation
import AudioToolbox

@MainActor
final class TimerViewModel: ObservableObject {
    enum Phase: String { case exercise, rest }

    // Input
    let exerciseTime: Int
    let restTime: Int
    let repetitions: Int

    // State
    @Published private(set) var currentPhase: Phase = .exercise
    @Published private(set) var currentRepetition: Int = 1
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var remainingSeconds: Int
    @Published private(set) var totalElapsedSeconds: Int = 0

    private var timer: Timer?
    private let speechSynthesizer = AVSpeechSynthesizer()

    private var totalPlanSeconds: Int {
        // No rest after final exercise rep
        let cycles = repetitions
        let exerciseTotal = cycles * exerciseTime
        let restIntervals = max(0, cycles - 1)
        let restTotal = restIntervals * restTime
        return exerciseTotal + restTotal
    }

    init(exerciseTime: Int, restTime: Int, repetitions: Int) {
        self.exerciseTime = exerciseTime
        self.restTime = restTime
        self.repetitions = repetitions
        self.remainingSeconds = max(1, exerciseTime)
    }

    func start() {
        guard isRunning == false else { return }
        isRunning = true
        scheduleTimer()
        announceCurrentPhase()
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        pause()
        currentPhase = .exercise
        currentRepetition = 1
        remainingSeconds = max(1, exerciseTime)
        totalElapsedSeconds = 0
    }

    func overallProgress() -> Double {
        guard totalPlanSeconds > 0 else { return 0 }
        return min(1.0, Double(totalElapsedSeconds) / Double(totalPlanSeconds))
    }

    func phaseProgress() -> Double {
        let duration = (currentPhase == .exercise) ? exerciseTime : restTime
        guard duration > 0 else { return 0 }
        return 1.0 - (Double(remainingSeconds) / Double(duration))
    }

    private func scheduleTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
        timer?.tolerance = 0.1
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func tick() {
        guard isRunning else { return }
        guard remainingSeconds > 0 else {
            advancePhaseOrFinish()
            return
        }

        remainingSeconds -= 1
        totalElapsedSeconds += 1
        playCountdownBeepIfNeeded()

        if remainingSeconds == 0 {
            // The next tick will advance the phase; pre-announce to feel snappier
            // but only if not finishing
            if !isFinishedAfterCurrent() {
                announceNextPhase()
            }
        }
    }

    private func isFinishedAfterCurrent() -> Bool {
        // Finishes when last exercise completes (no rest after last)
        return currentPhase == .exercise && currentRepetition == repetitions && remainingSeconds == 0
    }

    private func advancePhaseOrFinish() {
        if isFinishedAfterCurrent() {
            finish()
            return
        }

        if currentPhase == .exercise {
            // Move to rest if not the final rep and rest time > 0
            if currentRepetition < repetitions && restTime > 0 {
                currentPhase = .rest
                remainingSeconds = restTime
            } else {
                // Skip rest if final rep or rest is zero. Advance to next exercise.
                currentRepetition += 1
                currentPhase = .exercise
                remainingSeconds = exerciseTime
            }
        } else {
            // From rest -> next exercise
            currentRepetition += 1
            currentPhase = .exercise
            remainingSeconds = exerciseTime
        }

        announceCurrentPhase()
    }

    private func finish() {
        pause()
        speak("Finished")
    }

    private func announceCurrentPhase() {
        switch currentPhase {
        case .exercise: speak("Go")
        case .rest: speak("Rest")
        }
    }

    private func announceNextPhase() {
        let next: Phase
        if currentPhase == .exercise {
            next = (currentRepetition < repetitions && restTime > 0) ? .rest : .exercise
        } else {
            next = .exercise
        }
        switch next {
        case .exercise: speak("Go")
        case .rest: speak("Rest")
        }
    }

    private func playCountdownBeepIfNeeded() {
        if remainingSeconds == 3 || remainingSeconds == 2 || remainingSeconds == 1 {
            AudioServicesPlaySystemSound(1052) // tone
        }
    }

    private func speak(_ text: String) {
        let uttr = AVSpeechUtterance(string: text)
        uttr.voice = AVSpeechSynthesisVoice(language: Locale.current.language.languageCode?.identifier ?? "en-GB")
        uttr.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(uttr)
    }
}


