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
                    //
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
            List {
                ForEach (events.indices, id:\.self) { index in
                    let event = events[index]
                    // Date
                    Section {
                        // Cell
                        Button(action: {
                            isEditingEvent = event
                        }) {
                            HStack {
                                VStack (alignment:.leading) {
                                    Text("\(event.date)")
                                    Text("\(event.name)")
                                    Text("IsUpcomming: \(event.isUpcoming)")
                                    Text("IsReapting: \(event.isRepeating)")
                                    
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(.yellow)
                        .listRowInsets(EdgeInsets())
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    } header: {
                        printDate(event: event)
                    }
                }
                .onDelete(perform: deleteEvent)
            }
            .listStyle(.sidebar)
            .padding(.horizontal, gridSpacing)
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
        Text("\(event.date.formatted(Date.FormatStyle().weekday(.abbreviated))), \(event.date.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits).year(.extended())))".uppercased())

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


