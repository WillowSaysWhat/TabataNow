import SwiftUI

// MARK: - Home (Responsive)

struct TABView: View {

  

    var body: some View {
        
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")

                }
            
            PlaceholderView(systemImage: "chart.bar.fill", title: "History")
                .tabItem {
                    Label("History", systemImage: "chart.bar.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }

        
       
    }
    
}

 
// MARK: - Preview

#Preview {
    TABView()
        .preferredColorScheme(.dark)
        
}


