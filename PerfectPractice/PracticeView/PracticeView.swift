//
//  PracticeView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/2/24.
//

import SwiftUI
import SwiftData

// TODO: IF PRACTICE STARTED, ADD ALERT IF THEY TRY TO LEAVE?

struct PracticeView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var practiceStateManager:PracticeStateManager
    @Query var users:[User]
    @Query(sort: \Practice.timeStart, order: .reverse) var practices:[Practice]
    @State var practice:Practice = Practice(instrument: "", timePracticed: 0, practiceSchedule: "", practiceGoals: "", aura: "", tag: "", notes: "")
    
    var body: some View {
        VStack {
            // Timer
            TimerView(practice: $practice) /// handles starting, pausing, and stoping a practice, and inserting time information into practice.
                .clipShape(RoundedRectangle(cornerRadius: 25))
            // Practice Schedule
            VStack {
                HStack {
                    Text("Session Schedule")
                    Spacer()
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "chevron.down.circle")
                    }
                }
                Text("Warmup 30min")
                Text("Bathroom Break 10min")
                Text("Ballad C -> End")
            }
            .padding()
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            // Goals
            VStack {
                Text("Goals")
                List {
                    
                }
                .listStyle(.plain)
            }
            .padding()
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 25))
                // Notes
            VStack {
                HStack {
                    Text("Notes:")
                    Spacer()
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "chevron.down.circle")
                    }
                }
                Text("Some Notes go here.")
            }
            .padding()
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            Spacer()

            // Tools
            HStack {
                /// Tuner
                Button(action: {
                    //
                }) {
                    Image(systemName: "tuningfork")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.bordered)
                /// metronome
                Button(action: {
                    //
                }) {
                    Image(systemName: "metronome")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.bordered)
                /// microphone
                Button(action: {
                    //
                }) {
                    Image(systemName: "waveform.badge.mic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Practice")
        .toolbar {
            // Instrument Being Practiced
            ToolbarItem {
                Menu {
                    ForEach(users.prefix(1)) { user in
                        ForEach(user.instrumentsPlayed, id:\.self) { instrument in
                            Button(action: {
                                practice.instrument = instrument
                            }) {
                                Text(instrument.capitalized)
                            }
                        }
                    }
                } label: {
                    if practice.instrument == "" {
                        Text("Select Instrument")
                    } else {
                        Text(practice.instrument.capitalized)
                    }
                }
            }
        }
        .onAppear {
            /// If practice state is running, loads from database
            if practiceStateManager.isPracticeStarted {
                practice = practices.first!
                print("Practice Running, loading from database")
            }
            /// Assigns user's default instrument to practice instrument if empty
            if practice.instrument == "" {
                practice.instrument = users.first?.defaultInstrument ?? ""
            }
        }
        /// On change of practiceState, if new practice it is inserted into database
        .onChange(of: practiceStateManager.isPracticeStarted) {
            if practiceStateManager.isPracticeStarted == true {
                modelContext.insert(practice)
                print("New Practice Inserted!")
            }
        }
    }
}

#Preview {
    // Testing Container
    var testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self
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
        .environmentObject(PracticeStateManager())
        .environmentObject(TimerManager())
}
