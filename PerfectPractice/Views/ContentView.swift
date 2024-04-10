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
// 1) HAPTICS.
// 2) GRADIENT COLORS ON WIDGETS?
// 5) REMOVE GLOBALTIMERMANAGER.
// 6) CONSIDER MOVING ON CHANGE for events and todo TO HOMEVIEW OR PRACTICE VIEW??

struct ContentView: View {
    @State private var selectedView: PrimaryViews = .home
    @Query(sort: \Event.date, order: .forward) var events:[Event]
    @Query var todos:[ToDo]

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
        // onChange of Todo
        .onChange(of: todos) {
            /// if todo date has passed, past due
            for todo in todos {
                if Calendar.current.startOfDay(for: todo.dueDate) < Calendar.current.startOfDay(for: Date.now) {
                    todo.isPastDue = true
                } else {
                    todo.isPastDue = false
                }
            }
        }
    }
}

// Preview
/// ------------------------------------------------------------------------
#Preview {
    // Testing Container
    var testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self,
            Event.self,
            ToDo.self
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
        .environmentObject(GlobalTimerManager())
        .environmentObject(ThemeManager())
        .environmentObject(SidebarManager())
}
