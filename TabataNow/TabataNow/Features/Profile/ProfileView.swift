//
//  ProfileView.swift
//  TabataNow
//
//  Created by Cursor AI on 16/12/2025.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CompletedWorkout.completedAt, order: .reverse) private var completedWorkouts: [CompletedWorkout]
    @StateObject private var viewModel = ProfileViewModel.createPlaceholder()
    @State private var showSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("PROFILE")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        // Placeholder circles
                        Circle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                        
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(.secondary)
                        }
                        
                        Toggle("", isOn: Binding(
                            get: { ProfileUserDefaults.isDarkModeEnabled },
                            set: { ProfileUserDefaults.isDarkModeEnabled = $0 }
                        ))
                        .toggleStyle(SwitchToggleStyle(tint: .neon))
                        .labelsHidden()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Main Progress Gauge
                SemiCircularGauge(progress: viewModel.overallProgress)
                    .frame(height: 200)
                    .padding(.horizontal)
                
                // Progress Bars Card
                VStack(spacing: 16) {
                    ProgressBarRow(
                        label: "minutes",
                        progress: viewModel.dailyMinutesProgress,
                        current: viewModel.dailyMinutes,
                        goal: ProfileUserDefaults.dailyMinutesGoal
                    )
                    
                    ProgressBarRow(
                        label: "workouts",
                        progress: viewModel.dailyWorkoutsProgress,
                        current: viewModel.dailyWorkouts,
                        goal: ProfileUserDefaults.dailyWorkoutsGoal
                    )
                }
                .padding()
                .background(Color.innerBackground)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Statistical Cards
                HStack(spacing: 12) {
                    StatCard(
                        icon: "flame.fill",
                        label: "Streak",
                        value: "\(viewModel.currentStreak)",
                        unit: "DAYS"
                    )
                    
                    StatCard(
                        icon: "figure.strengthtraining.traditional",
                        label: "BP",
                        value: "\(viewModel.bestPeriodStreak)",
                        unit: "DAYS"
                    )
                    
                    StatCard(
                        icon: "rosette",
                        label: "Awards",
                        value: "\(viewModel.totalAwards)",
                        unit: "TOTAL"
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.black)
        .onAppear {
            // Update viewModel with actual modelContext
            viewModel.updateModelContext(modelContext)
            viewModel.loadStats()
        }
        .onChange(of: completedWorkouts.count) { _, _ in
            // Refresh stats when workouts change
            viewModel.loadStats()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

// MARK: - Semi-Circular Gauge

struct SemiCircularGauge: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            // Background arc
            ArcShape(startAngle: .degrees(180), endAngle: .degrees(0))
                .stroke(Color.secondary.opacity(0.2), lineWidth: 20)
            
            // Progress arc
            ArcShape(startAngle: .degrees(180), endAngle: .degrees(180 - (180 * progress)))
                .stroke(Color.neon, lineWidth: 20)
                .animation(.linear(duration: 0.3), value: progress)
            
            // Center circle
            Circle()
                .fill(Color.innerBackground)
                .frame(width: 60, height: 60)
        }
    }
}

struct ArcShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 10
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        return path
    }
}

// MARK: - Progress Bar Row

struct ProgressBarRow: View {
    let label: String
    let progress: Double
    let current: Int
    let goal: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(current)/\(goal)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.secondary.opacity(0.2))
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.neon)
                        .frame(width: geometry.size.width * progress)
                        .animation(.linear(duration: 0.3), value: progress)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.neon)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.innerBackground)
        .cornerRadius(12)
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Daily Goals") {
                    Stepper("Minutes: \(ProfileUserDefaults.dailyMinutesGoal)",
                           value: Binding(
                               get: { ProfileUserDefaults.dailyMinutesGoal },
                               set: { ProfileUserDefaults.dailyMinutesGoal = $0 }
                           ),
                           in: 1...300)
                    
                    Stepper("Workouts: \(ProfileUserDefaults.dailyWorkoutsGoal)",
                           value: Binding(
                               get: { ProfileUserDefaults.dailyWorkoutsGoal },
                               set: { ProfileUserDefaults.dailyWorkoutsGoal = $0 }
                           ),
                           in: 1...50)
                }
                
                Section("Weekly Goals") {
                    Stepper("Minutes: \(ProfileUserDefaults.weeklyMinutesGoal)",
                           value: Binding(
                               get: { ProfileUserDefaults.weeklyMinutesGoal },
                               set: { ProfileUserDefaults.weeklyMinutesGoal = $0 }
                           ),
                           in: 0...1000)
                    
                    Stepper("Workouts: \(ProfileUserDefaults.weeklyWorkoutsGoal)",
                           value: Binding(
                               get: { ProfileUserDefaults.weeklyWorkoutsGoal },
                               set: { ProfileUserDefaults.weeklyWorkoutsGoal = $0 }
                           ),
                           in: 0...100)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: [TabataSession.self, CompletedWorkout.self], inMemory: true)
}
