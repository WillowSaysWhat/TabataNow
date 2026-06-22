//
//  DashboardView.swift
//  TabataNow
//
//  Created by Huw Williams on 15/12/2025.
//

import SwiftUI
import SwiftData

//---- Dashboard view

// Views in this file
// DashboardView
// ActivityRingAndBar
// HistoryListView
// SelectWorkoutButton

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("DASHBOARD")
                    .font(.title)
                    .bold()
                    .padding(.leading, 20)
                
                ActivityRingAndBar()
                
                HistoryListView()
                               
            }
            .padding()
            
            // Navigation button +
            SelectWorkoutButton()
            PushUpsNowButton()
            
            Spacer()
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [TabataSession.self, CompletedWorkout.self], inMemory: true)
}




//MARK: Activity Ring and Bar
struct ActivityRingAndBar: View {
    var body: some View {
        
        HStack {
                ActivityRing(progress: 0.6) {
                    VStack {
                        Text("Today")
                        Text("15")
                        Text("mins")
                    }
                    
                }
                .padding()
                
                VStack {
                    
                    HStack {
                        MedalView(isActive: MedalUserDefaults.hasCompletedMedal1)
                        MedalView(isActive: MedalUserDefaults.hasCompletedMedal2)
                        MedalView(isActive: MedalUserDefaults.hasCompletedMedal3)
                        MedalView(isActive: MedalUserDefaults.hasCompletedMedal4)
                        
                    }
                    Text("Level: Beginner")
                    Text("Next: Novice")

                    HStack(spacing: 8) {
                        TrophyView(isActive: true)
                        TrophyView(isActive: true)
                        TrophyView(isActive: true)
                        TrophyView(isActive: true)
                    }
                    .padding(.top, 3)
                }
                .padding()
                
        }
    }
}

//MARK: History List
struct HistoryListView: View {
    @Query(sort: \CompletedWorkout.completedAt, order: .reverse) private var completedWorkouts: [CompletedWorkout]
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        ForEach(viewModel.historyRows(for: completedWorkouts)) { status in
            HistoryRowView(status: status)
        }
    }
}

//MARK: Select Workout
struct SelectWorkoutButton: View {
    var body: some View {
        ZStack {
            // horizontal bar
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.innerBackground)
                .frame(height: 60)
                .overlay(
                     RoundedRectangle(cornerRadius: 0)
                         .stroke(Color.white.opacity(0.08), lineWidth: 2)
                )
            Text("Select Workout")
                .font(.title)
                .offset(x: -82)
            
            ZStack { // The big plus button - navigates to list of workouts.
                NavigationLink {
                    SessionListView()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.black)
                            .frame(height: 100)
                            .overlay(
                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                                    Image(systemName: "plus")
                                        .foregroundStyle(Color.neon)
                                        .font(.system(size: 70, weight: .semibold))
                                }
                            )
                    }
                }
                .buttonStyle(.plain) // prevents default blue highlight
            }
            .offset(x: 110) // offsets the plus button to the right
        }
        .frame(height: 80) // gives a little more space inside the frame for rectangle and circle without interfering with the layout.
    }
}

//MARK: PushUps Now
struct PushUpsNowButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.innerBackground)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.white.opacity(0.08), lineWidth: 2)
                )

            Text("PushUps Now")
                .font(.title)
                .offset(x: 34)

            NavigationLink {
                Text("PushUps placeholder")
                    .navigationTitle("PushUps")
            } label: {
                ZStack {
                    Circle()
                        .fill(.black)
                        .frame(height: 100)
                        .overlay(
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .foregroundStyle(Color.neon)
                                    .font(.system(size: 44, weight: .semibold))
                            }
                        )
                }
            }
            .buttonStyle(.plain)
            .offset(x: -110)
        }
        .frame(height: 80)
    }
}
