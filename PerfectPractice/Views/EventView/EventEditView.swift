//
//  EventEditView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/4/24.
//

import SwiftUI
import SwiftData

struct EventEditView: View {
    @Bindable var event:Event
    var body: some View {
        Form {
            TextField("Event Name", text: $event.name)
        }
    }
}


// Preview
/// ------------------------------------------------------------------------
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
