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
    @Query var users:[User]
    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    @State private var isEditingEvent: Event? = nil
    private var eventsGroupedByDate: [Date: [Event]] {
        Dictionary(grouping: events, by: { $0.date })
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: gridSpacing) {
            // Title & Add
            HStack {
                Text("Events")
                    .font(.system(size: titleSize))
                    .fontWeight(.semibold)
                Spacer()
                // Add New Event
                Button(action: {
                    let newEvent = Event(name: "", isUpcoming: true, isRepeating: false, repeatSchedule: "", location: "", eventDescription: "", tagColor: "")
                    modelContext.insert(newEvent)
                    isEditingEvent = newEvent
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: titleSize/2, height: titleSize/2)
                        .foregroundStyle(Color.blue)
                }
                .padding(titleSize/2)
                .background(.white)
                .clipShape(Circle())
            }
            .padding(.top, gridSpacing)
            .padding(.horizontal, gridSpacing)
            
            // List
            ScrollView (.vertical) {
                VStack (alignment: .leading, spacing: gridSpacing) {
                    ForEach (events.indices, id:\.self) { index in
                        let event = events[index]
                        // Date
                        if (index != 0) {
                            if (Calendar.current.isDate(event.date, inSameDayAs: events[index - 1].date)) {
                                //
                            } else {
                                Divider()
                                printDate(event: event)
                            }
                        } else {
                            printDate(event: event)
                        }
                        // Cell
                        HStack {
                            // Capsule
                            Capsule()
                                .foregroundStyle(Color(event.tagColor).opacity(0.8))
                                .frame(width: 4)
                            // Button
                            Button(action: {
                                isEditingEvent = event
                            }) {
                                HStack {
                                    VStack (alignment:.leading) {
                                        Text("\(event.name)")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                        Text("\(event.date.formatted(date: .omitted, time: .shortened))")
                                            .font(.system(size: 12))
                                        if event.location != "" {
                                            Text("\(event.location)")
                                                .font(.system(size: 12))
                                        }
                                        if event.eventDescription != "" {
                                            Text("\(event.eventDescription)")
                                                .font(.system(size: 12))
                                        }
                                    }
                                    .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                        }
                        .padding(gridSpacing/2)
                        .frame(maxWidth: .infinity)
                        .background(Color(event.tagColor).opacity(0.25))
                        .foregroundStyle(Color(event.tagColor))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, gridSpacing)
            }
        }
        .background(Color("BackgroundColor"))
        .sheet(item: $isEditingEvent) { event in
            EventEditView(event: event)
        }
    }
    
    // DeleteEvent
    func deleteEvent(_ indexSet: IndexSet) {
        for index in indexSet {
            let practice = events[index]
            modelContext.delete(practice)
        }
    }
    
    private func printDate(event: Event) -> Text {
        Text("\(event.date.formatted(Date.FormatStyle().weekday(.wide))), \(event.date.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits).year(.extended())))".uppercased())

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


