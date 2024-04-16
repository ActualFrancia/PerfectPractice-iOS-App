//
//  SidebarView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/16/24.
//

import SwiftUI
import SwiftData

struct SidebarView: View {
    @EnvironmentObject var sidebarManager:SidebarManager
    @EnvironmentObject var userManager:UserManager
    @Binding var selectedView: PrimaryViews
    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 20
    private let imageSize:CGFloat = 20
    
    var body: some View {
        ZStack (alignment: .leading) {
            // Dim the Screen
            Color(.black).opacity(0.1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            // Sidebar
            VStack (alignment: .leading, spacing: gridSpacing) {
                // PFP & Name
                HStack {
                    PFPButton() {
                        selectedView = .home
                        sidebarManager.hideSidebar()
                    }
                    Text(userManager.userName())
                        .font(.system(size: titleSize))
                        .fontWeight(.semibold)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                /// Home
                sidebarTitle(systemName: "house", Title: "Home", destination: .home)
                /// Practice
                sidebarTitle(systemName: "music.note", Title: "Practice", destination: .practice)
                /// Profile
                sidebarTitle(systemName: "person.circle", Title: "Profile", destination: .profile)
                /// Practice History
                sidebarTitle(systemName: "music.note.list", Title: "History", destination: .history)
                
                
                
                Spacer()
                
                /// Themes
                sidebarTitle(systemName: "paintpalette", Title: "Customize", destination: .customize)
                /// Setting
                sidebarTitle(systemName: "gearshape", Title: "Settings", destination: .settings)
            }
            .padding(.horizontal, gridSpacing * 2)
            .padding(.vertical, gridSpacing)
            .frame(maxWidth: 250, maxHeight: .infinity)
            .background(.regularMaterial)
        }
    }
    
    func sidebarTitle(systemName: String, Title: String, destination: PrimaryViews) -> some View {
        Button(action: {
            selectedView = destination
            sidebarManager.hideSidebar()
        }) {
            HStack (spacing: gridSpacing) {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                Text(Title)
                    .font(.system(size: titleSize))
                    .fontWeight(.semibold)
                Spacer()
            }
        }
    }
}

// Preview
/// ------------------------------------------------------------------------
#Preview {
    // Testing Container
    let testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self,
            Event.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return ContentView()
        .modelContainer(testingModelContainer)
        .environmentObject(PracticeManager())
        .environmentObject(ThemeManager())
        .environmentObject(SidebarManager())
        .environmentObject(UserManager())
}
