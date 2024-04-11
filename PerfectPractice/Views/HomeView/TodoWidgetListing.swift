//
//  TodoWidgetListing.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/10/24.
//

import SwiftUI
import SwiftData

struct TodoWidgetListing: View {
    @Binding var todo:todoItem
    
    var body: some View {
        HStack {
            // Todo isCompleted
            Toggle(isOn: $todo.isCompleted) {
                Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
            }
            .toggleStyle(.button)
            
            // Todo Text
            TextField("Todo Item", text: $todo.name, axis: .vertical)
                .multilineTextAlignment(.leading)
        }
    }
}

// Preview
/// ------------------------------------------------------------------------
#Preview {
    // Testing Container
    let testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self,
            Event.self,
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
        .environmentObject(ThemeManager())
        .environmentObject(SidebarManager())
        .environmentObject(UserManager())
}
