//
//  SidebarView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/2/24.
//

import SwiftUI
import SwiftData

struct SidebarView: View {
    @Binding var isShowingSidebar:Bool
    @Binding var selectedView:ViewList
    
    var body: some View {
        VStack (alignment: .leading) {
            // PFP & Name
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Text("Gino Francia")
            
            // Practice
            Button(action: {
                selectedView = .practice
                isShowingSidebar = false
            }) {
                Image(systemName: "music.note")
                Text("Practice")
            }
            
            
            // Profile
            Button(action: {
                selectedView = .profile
                isShowingSidebar = false
            }) {
                Image(systemName: "person")
                Text("Profile")
            }
            
            // Practice History
            Button(action: {
                selectedView = .practiceHistory
                isShowingSidebar = false
            }) {
                Image(systemName: "music.note.list")
                Text("Practice History")
            }
            
            Spacer()
            
            // Settings & Support
            Button(action: {
                selectedView = .settings
                isShowingSidebar = false
            }) {
                Image(systemName: "gearshape")
                Text("Settings & Support")
            }
            // About App
            Button(action: {
                selectedView = .about
                isShowingSidebar = false
            }) {
                Image(systemName: "questionmark.circle")
                Text("About")
            }
        }
        .frame(maxWidth: 300, maxHeight: .infinity)
        .background(.thickMaterial)
    }
}

#Preview {
    // Testing Container
    var testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self
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
}
