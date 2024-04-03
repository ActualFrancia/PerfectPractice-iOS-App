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
    @Query var users:[User]
    @Query var practices:[Practice]
    
    // Practice
    @State private var practice = Practice(instrument: "", timePracticed: 0, practiceSchedule: "", practiceGoals: "", aura: "", tag: "", notes: "")
    @Binding var isPracticeStarted:Bool
    
    var body: some View {
        VStack {
            // Timer
            TimerView(practice: $practice)
                .padding()
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
            ToolbarItem(placement: .automatic) {
                HStack {
                    Text("Select Instrument")
                    Image(systemName: "chevron.down")
                }
            }
        }
        .onAppear {
            let user = users.first
            
            if isPracticeStarted {
                practice = practices.first!
            } else {
                practice.instrument = user?.defaultInstrument ?? ""
            }
        }
    }
    
    // Add Finished Practice to Database
    func addPracticeToDatabase() {
        modelContext.insert(practice)
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
}
