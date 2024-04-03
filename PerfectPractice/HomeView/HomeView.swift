//
//  HomeView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Perfect Practice")
            HStack {
                // Event
                Bento {
                    Text("Event")
                }
                
                VStack {
                    Bento {
                        Image(systemName: "music.note")
                        Text("Start Practicing")
                    }
                    .frame(height: 150)
                    HStack {
                        Bento {
                            Image(systemName: "music.note.list")
                            Text("History")
                        }
                        Bento {
                            Image(systemName: "chevron.right")
                            Text("Tools")
                        }
                    }
                }
            }
            Bento {
                Text("Upcomming Events")
            }
            .frame(height: 100)
            Bento {
                Text("Todo")
            }
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
