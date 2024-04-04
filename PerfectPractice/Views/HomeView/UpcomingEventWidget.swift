//
//  UpcomingEventWidget.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI
import SwiftData

struct UpcomingEventWidget: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var eventTimerManager: GlobalTimerManager
    @Query(sort: \Event.date, order: .forward) var events:[Event]
    private let cellWidth:CGFloat = 160
    
    @State private var currentTime = Date()
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            Text("\(currentTime)")
        }
        .onReceive(eventTimerManager.timer) { time in
            currentTime = time
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

