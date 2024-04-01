//
//  ProfileView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users:[User]
    var user:User?
    
    var body: some View {
        VStack {
            ForEach(users.prefix(1)) { user in
                Text("\(user.name)")
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItemGroup (placement: .automatic) {
                Button(action: {
                    addSampleUserData()
                }) {
                    Text("Sample USER")
                }
            }
        }
        // ProfileView will act as periodic cleanup of potential excess users
        .onAppear {
            for user in users {
                if user != users.first {
                    print("DEBUG: Excess Users Removed")
                    modelContext.delete(user)
                }
            }
        }
    }
    
    func addSampleUserData() {
        let name = "Jeff"
        let defIns = "voice"
        
        let user1 = User(name: name, defaultInstrument: defIns)
        
        modelContext.insert(user1)
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
