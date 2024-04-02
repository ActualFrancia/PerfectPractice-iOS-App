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
    
    var body: some View {
        VStack {
            ForEach(users.prefix(1)) { user in
                HStack {
                    // PFP
                    userPFP(pfpData: user.pfp)
                    // Name
                    Text("\(user.name)")
                    // Instruments
                    Text("\(user.primaryInstruments ?? [])")
                    Text("\(user.secondaryInstruments ?? [])")
                    Text("\(user.defaultInstrument)")

                    // Edit Button
                    NavigationLink(value: user) {
                        Text("Edit profile")
                    }
                    .padding()
                    .buttonStyle(.bordered)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationDestination(for: User.self, destination: EditProfileView.init)
        .toolbar {
            ToolbarItemGroup (placement: .automatic) {
                // TESTING: Add User Data
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
        let defIns = ""
        
        let user1 = User(name: name, primaryInstruments: [], secondaryInstruments: [], defaultInstrument: defIns)
        
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
