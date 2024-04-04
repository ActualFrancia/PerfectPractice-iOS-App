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
    case eventListing
}

struct ContentView: View {
    @State private var selectedView: PrimaryViews = .home
    @Query(sort: \Event.date, order: .forward) var events:[Event]

    var body: some View {
        ZStack (alignment: .topLeading) {
            /// View
            switch selectedView {
            case .home:
                HomeView(selectedView: $selectedView)
            case .practice:
                PracticeView()
            case .eventListing:
                EventListingView()
            }
            /// Sidebar
            Button(action: {
                // Open Sidebar
            }) {
                pfpCircle(pfpData: nil)
            }
            .padding(.leading, 10)
            
            /// Swipe to Practice
            if selectedView == .home {
                SwipeToPracticeView(selectedView: $selectedView)
                    .frame(maxHeight: .infinity)
            }
        }
        // onChange of Events
        .onChange(of: events) {
            /// if eventdate, has passed, archive
            for event in events {
                if event.date < Date.now {
                    print("Event has passed.")
                    event.isUpcoming = false
                }
            }
        }
    }
}

// Preview
/// -------------------------------------------------------------------------------
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
}