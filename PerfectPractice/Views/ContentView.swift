//
//  ContentView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import SwiftUI
import SwiftData

enum PrimaryViews {
    case home
    case practice
}

// TODO: LIST
// 0) PracticeView instrument select.
// 1) Haptics.
// 2) Fix Event Listings Date ordering. Make new past events section.
// 3) Focus on TextFields.
// 4) Keyboard hide on scroll.
// 2) Themeing w/ gradient colors
// 5) Fix Completed events counter on todo widget

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userManager:UserManager
    @State private var selectedView: PrimaryViews = .practice
    @Query(sort: \Event.date, order: .forward) var events:[Event]
    @Query(sort: \User.dateCreated, order: .forward) var users:[User]

    var body: some View {
        ZStack (alignment: .topLeading) {
            /// View
            switch selectedView {
            case .home:
                HomeView(selectedView: $selectedView)
            case .practice:
                PracticeView(selectedView: $selectedView)
            }
            // Sidebar
            
            /// Tap to Practice
            if selectedView == .home {
                PracticeButton(selectedView: $selectedView)
            }
        }
        // onChange of Events
        .onChange(of: events) {
            /// if event date has passed, archive
            for event in events {
                if event.date < Date.now {
                    event.isUpcoming = false
                } else {
                    event.isUpcoming = true
                }
            }
        }
        // onAppear
        .onAppear() {
            // TODO: REMOVE AFTER
            let user1 = User(name: "Gino", defaultInstrument: "", defaultTag: "")
            modelContext.insert(user1)
            /// setup UserManger with oldest user.
            userManager.setUser(users.first!)
            /// cleanup extra users if any
            if users.count > 1 {
                for i in 1..<users.count {
                    modelContext.delete(users[i])
                }
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
