//
//  PracticeHistoryView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import SwiftUI
import SwiftData

struct PracticeHistoryView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Practice.timeStart, order: .reverse) var practices:[Practice]

    var body: some View {
        List {
            ForEach (practices) { practice in
                NavigationLink (value: practice) {
                    VStack {
                        Text("Instrument:  \(practice.instrument)")
                        Text("Time Start: \(practice.timeStart)")
                        Text("Time Practiced: \(practice.timePracticed)")
                        
                        Text("---")
                        
                        Text("Practice Schedule Array: \(stringToStringIntInt(longString: practice.practiceSchedule))")
                        
                        Text("---")
                        
                        Text("Practice Goal Array: \(stringToStringBool(longString: practice.practiceGoals))")
                        
                        Text("---")
                        
                        
                        Text("Aura: \(practice.aura)")
                    }
                }
            }
            .onDelete(perform: deletePractice)
        }
        .navigationTitle("Practice History")
        //.navigationDestination(for: Practice.self, destination: EditPracticeView.init)
        .toolbar {
            ToolbarItemGroup (placement: .automatic) {
                // TESTING: SAMPLE DATA
                Button (action: {
                    addSampleData()
                }) {
                    Text("Sample DATA")
                }
                
                // Add new Practice
                Button (action: {
                    //addPractice()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    func addSampleData() {
        let goalLongString = "␟Goal 1:true␟Goal 2:false␟Goal 3:true␟"
        let scheduleLongString = "␟Step 1:1:30␟Step 2:0:45␟Step 3:2:15␟"
        
        let practice1 = Practice(instrument: "voice", timeStart: .now, timePracticed: 0, practiceSchedule: scheduleLongString, practiceGoals: goalLongString, aura: auraList[0], tag: "", notes: "")
        
        modelContext.insert(practice1)
    }
    
    // Delete Practice
    func deletePractice(_ indexSet: IndexSet) {
        for index in indexSet {
            let practice = practices[index]
            modelContext.delete(practice)
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
        .environmentObject(TimerManager())}
