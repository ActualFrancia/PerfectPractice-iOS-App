//
//  GoalWidget.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/11/24.
//

import SwiftUI
import SwiftData

struct GoalWidget: View {
    @EnvironmentObject var practiceManager:PracticeManager
    private let gridSpacing:CGFloat = 16
    private let textSpacing: CGFloat = 10
    
    private let itemHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            List {
                ForEach($practiceManager.practiceGoals, id:\.id) {goal in
                    GoalWidgetListing(goal: goal)
                        .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: deleteGoal(_:))
                .onMove(perform: moveGoal(from:to:))
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .background(Color("BentoColor"))
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
    
    private func deleteGoal(_ indexSet: IndexSet) {
        practiceManager.practiceGoals.remove(atOffsets: indexSet)
    }
    
    private func moveGoal(from source: IndexSet, to destination: Int) {
        practiceManager.practiceGoals.move(fromOffsets: source, toOffset: destination)
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
