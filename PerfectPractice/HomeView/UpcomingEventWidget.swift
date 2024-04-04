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
    @Query(sort: \Event.date, order: .forward) var events:[Event]
    private let cellWidth:CGFloat = 160
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack (spacing: 0) {
                Divider()
                ForEach(events) { event in
                    if (event.isUpcoming) {
                        HStack (spacing: 4) {
                            VStack (alignment: .leading, spacing: 0) {
                                HStack (spacing: 2) {
                                    Text("\(event.date.formatted(Date.FormatStyle().weekday(.abbreviated))), \(event.date.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits)))".uppercased())
                                        .font(.system(size: 11))
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                Text(event.name)
                                    .font(.caption)
                                Text("\(event.date.formatted(Date.FormatStyle()        .hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))")
                                    .font(.caption)
                                Spacer()
                                Text("Time Until:")
                                    .font(.caption2)
                                HStack (spacing: 3) {
                                    Text("\(daysHoursMinutesTillEvent(date: event.date).time)")
                                        .font(.headline)
                                    Text("\(daysHoursMinutesTillEvent(date: event.date).timeType)")
                                        .font(.subheadline)
                                }
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            Divider()
                        }
                        .frame(width: cellWidth)
                        .padding(5)
                    }
                }
            }
            .offset(x: -1) /// hiders first divider
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
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

