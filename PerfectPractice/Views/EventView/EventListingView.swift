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
    @Query(sort: \Event.date, order: .forward) var events:[Event]
    @Query var users:[User]
    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    @State private var isEditingEvent: Event? = nil

    
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
                .background(Color("BentoColor"))
                .clipShape(Circle())
            }
            .padding(.top, gridSpacing)
            .padding(.horizontal, gridSpacing)
            
            // List
            ScrollView (.vertical) {
                VStack (alignment: .leading, spacing: gridSpacing / 4) {
                    ForEach (events.indices, id:\.self) { index in
                        let event = events[index]
                        // Date
                        if (index != 0) {
                            if (Calendar.current.isDate(event.date, inSameDayAs: events[index - 1].date)) {
                                //
                            } else {
                                Divider()
                                    .padding(.vertical, gridSpacing/2)
                                printDate(event: event)
                                    .padding(.bottom, gridSpacing / 2)
                            }
                        } else {
                            printDate(event: event)
                                .padding(.bottom, gridSpacing / 2)
                        }
                        // Cell
                        HStack {
                            // Capsule
                            Capsule()
                                .foregroundStyle(event.isUpcoming ?  Color(event.tagColor).opacity(0.8) : Color.gray.opacity(0.8))
                                .frame(width: 4)
                            // Button
                            Button(action: {
                                isEditingEvent = event
                            }) {
                                HStack {
                                    VStack (alignment:.leading) {
                                        HStack {
                                            /// name
                                            Text("\(event.name)")
                                                .font(.system(size: 12))
                                                .fontWeight(.bold)
                                            Spacer()
                                            /// past
                                            if !event.isUpcoming {
                                                Text("Passed")
                                                    .font(.system(size: 12))
                                            }
                                            /// favorite
                                            if event.isFav {
                                                Image(systemName: "heart.fill")
                                            }
                                        }
                                        /// date
                                        Text("\(event.date.formatted(date: .omitted, time: .shortened))")
                                            .font(.system(size: 12))
                                        /// location
                                        if event.location != "" {
                                            Text("\(event.location)")
                                                .font(.system(size: 12))
                                        }
                                        /// description
                                        if event.eventDescription != "" {
                                            Text("\(event.eventDescription)")
                                                .font(.system(size: 12))
                                        }
                                    }
                                    .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        .padding(gridSpacing/2)
                        .frame(maxWidth: .infinity)
                        .background( event.isUpcoming ? Color(event.tagColor).opacity(0.25) : Color.gray.opacity(0.25))
                        .foregroundStyle(event.isUpcoming ?  Color(event.tagColor) : Color.gray)
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
        Text("\(event.date.formatted(Date.FormatStyle().weekday(.wide))), \(event.date.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits)))".uppercased())
            .fontWeight(.bold)
            .foregroundStyle(Color("TextColor"))
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
