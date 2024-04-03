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

struct ContentView: View {
    @State private var selectedView: PrimaryViews = .home
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            /// View
            switch selectedView {
            case .home:
                HomeView()
            case .practice:
                PracticeView()
            }
            /// Sidebar
            Button(action: {
                // Open Sidebar
            }) {
                pfpCircle(pfpData: nil)
            }
            
            /// Swipe to Practice
            if selectedView == .home {
                SwipeToPracticeView(selectedView: $selectedView)
                    .frame(maxHeight: .infinity)
            }
        }
    }
}

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
}
