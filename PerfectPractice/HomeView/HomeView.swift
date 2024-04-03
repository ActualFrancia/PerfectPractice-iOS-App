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
        ZStack {
            // Home View
            VStack {
                Text("Perfect Practice")
                VStack {
                    Bento {
                        Text("Starred Event")
                    }
                    .frame(height: 120)
                    HStack {
                        Bento {
                            Text("Upcomming Events")
                        }
                        Bento {
                            Image(systemName: "chevron.right")
                        }
                        .frame(width: 50)
                    }
                    .frame(height: 100)
                    Bento {
                        Text("Stats")
                    }
                    Bento {
                        Text("Todo List")
                    }
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
