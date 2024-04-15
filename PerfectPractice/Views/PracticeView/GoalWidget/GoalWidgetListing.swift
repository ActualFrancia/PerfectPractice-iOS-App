//
//  GoalWidgetListing.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/11/24.
//

import SwiftUI
import SwiftData

struct GoalWidgetListing: View {
    @Binding var goal:practiceGoal
    
    var body: some View {
        HStack {
            // Todo isCompleted
            Toggle(isOn: $goal.isCompleted) {
                Image(systemName: goal.isCompleted ? "checkmark.square" : "square")
            }
            .toggleStyle(.button)
            
            // Todo Text
            TextField("Goal", text: $goal.goalDescription)
            
            Spacer()
            Image(systemName: "line.horizontal.3")
                .foregroundStyle(.gray.opacity(0.5))
                .padding(.trailing, 10)
        }
        .frame(height: 35)
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
