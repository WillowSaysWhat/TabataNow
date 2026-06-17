//
//  DashboardView.swift
//  TabataNow
//
//  Created by Huw Williams on 15/12/2025.
//

import SwiftUI
import SwiftData


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
            
            Spacer()
        }
    }
}

#Preview {
    DashboardView()
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
                        MedalView(isActive: true)
                        MedalView(isActive: true)
                        MedalView(isActive: true)
                        MedalView(isActive: true)
                        
                    }
                    Text("Level: Beginner")
                    Text("Next: Novice")
                    LevelProgressBar(progress: 0.6)
                        .padding(.top, 3)
                    
                }
                .padding()
                
        }
    }
}

//MARK: History List
struct HistoryListView: View {
    var body: some View {
        
        HistoryRowView(title: "day before", didStrength: true, didFlame: false, didMedal: false, didCheck: false)
        HistoryRowView(title: "Yesterday", didStrength: true, didFlame: true, didMedal: true, didCheck: true)
        HistoryRowView(title: "TODAY", isInactive: true, didStrength: false, didFlame: false, didMedal: false, didCheck: false)
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
