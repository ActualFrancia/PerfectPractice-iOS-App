//
//  PracticeView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/2/24.
//

import SwiftUI
import SwiftData

struct PracticeView: View {
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            // Timer
            HStack {
                VStack {
                    HStack {
                        Text("Timer")
                            .font(.headline)
                        Spacer()
                        Text("02/25/2001")
                    }
                    Text("0:00")
                        .font(.system(size: 80))
                        .overlay (alignment: .bottomTrailing) {
                            Button(action: {
                                //
                            }) {
                                Image(systemName: "eye.slash.fill")
                            }
                        }
                    // Pause Timer
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "pause.circle.fill")
                        Text("Pause")
                    }
                    // End Session
                    Button(action: {
                        //
                    }) {
                        Text("Finish Session")
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(.gray)
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
                HStack {
                    Text("Goals:")
                    Spacer()
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "chevron.down.circle")
                    }
                }
                Text("Lipslurs at 120BPM")
                Text("Opener A -> D")
                Text("Ballad C -> End")
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
