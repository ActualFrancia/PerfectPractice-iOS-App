//
//  EventView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI
import SwiftData

struct EventListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Event.date, order: .reverse) var events:[Event]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (events) { event in
                    NavigationLink(value: event) {
                        VStack {
                            Text("\(event.date)")
                            Text("\(event.name)")
                            Text("IsUpcomming: \(event.isUpcoming)")
                            Text("IsReapting: \(event.isRepeating)")
                        }
                    }
                }
                .onDelete(perform: deleteEvent)
            }
            .listStyle(.plain)
        }
        // TESTING ------------
        .onAppear() {
            let sampleEvent1 = Event(name: "Beef's Birthday Bi-Annual", date: .now, isUpcoming: true)
            let sampleEvent2 = Event(name: "January Camp", date: .distantPast, isUpcoming: true)
            let sampleEvent3 = Event(name: "Da Future", date: .distantFuture, isUpcoming: true)
            modelContext.insert(sampleEvent1)
            modelContext.insert(sampleEvent2)
            modelContext.insert(sampleEvent3)
        }
    }
    
    // DeleteEvent
    func deleteEvent(_ indexSet: IndexSet) {
        for index in indexSet {
            let practice = events[index]
            modelContext.delete(practice)
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
    
    return EventListingView()
        .modelContainer(testingModelContainer)
        .environmentObject(PracticeManager())
}
