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
    @EnvironmentObject var globalTimerManager: GlobalTimerManager
    @Query(filter: #Predicate {$0.isUpcoming == true},sort: \Event.date, order: .forward) var events:[Event]
    private let cellWidth:CGFloat = 150
    private let dateTitleHeight:CGFloat = 10
    private let spacerPadding:CGFloat = 5
    
    @State private var currentTime = Date()
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                // Events
                ForEach(events.indices, id:\.self) { index in
                    let event = events[index]
                    // Capsule & Date
                    if (index != 0) {
                        if (Calendar.current.isDate(event.date, inSameDayAs: events[index - 1].date)) {
                            VStack {
                                Spacer(minLength: dateTitleHeight + spacerPadding)
                                printEventData(event: events[index])
                            }
                        } else {
                            HStack {
                                Divider()
                                VStack (alignment: .leading, spacing: 0) {
                                    Text("\(event.date.formatted(Date.FormatStyle().weekday(.abbreviated))), \(event.date.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits)))".uppercased())
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                        .frame(height: dateTitleHeight)
                                    Spacer(minLength: spacerPadding)
                                    printEventData(event: events[index])
                                }
                            }
                        }
                    } else {
                        HStack {
                            VStack (alignment: .leading, spacing: 0) {
                                Text("\(event.date.formatted(Date.FormatStyle().weekday(.abbreviated))), \(event.date.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits)))".uppercased())
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .frame(height: dateTitleHeight)
                                Spacer(minLength: spacerPadding)
                                printEventData(event: events[index])
                            }
                        }
                    }
                }
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .onReceive(globalTimerManager.timer) { time in
            currentTime = time
        }
        // TESTING DATA
        .onAppear {
            let event1 = Event(name: "Event 1", date: .now - 100 , isUpcoming: true, isRepeating: false, repeatSchedule: "", tagColor: "blue" )
            let event2 = Event(name: "Event 2", date: .now + 10, isUpcoming: true, isRepeating: false, repeatSchedule: "", tagColor: "blue")
            let event3 = Event(name: "Event 3", date: .now + 70, isUpcoming: true, isRepeating: false, repeatSchedule: "", tagColor: "indigo")
            let event4 = Event(name: "Event 4", date: .now + 88888, isUpcoming: true, isRepeating: false, repeatSchedule: "", tagColor: "blue")
            
            modelContext.insert(event1)
            modelContext.insert(event2)
            modelContext.insert(event3)
            modelContext.insert(event4)
            
        }
        // ------------
    }
    
    func printEventData(event: Event) -> some View {
        NavigationLink(value: event) {
            HStack (spacing: 5) {
                Capsule()
                    .foregroundStyle(Color(event.tagColor).opacity(0.8))
                    .frame(width: 4)
                VStack (alignment: .leading) {
                    Text("\(event.name)")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                    Text("\(event.date.formatted(date: .omitted, time: .shortened))")
                        .font(.system(size: 12))
                    Spacer()
                }
                Spacer()
            }
            .padding(5)
            .frame(width: cellWidth)
            .background(Color(event.tagColor).opacity(0.25))
            .foregroundStyle(Color(event.tagColor))
            .clipShape(RoundedRectangle(cornerRadius: 10))
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

