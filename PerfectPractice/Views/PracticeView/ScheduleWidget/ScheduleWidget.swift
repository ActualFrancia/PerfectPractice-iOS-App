//
//  ScheduleWidget.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/10/24.
//

import SwiftUI
import SwiftData

struct ScheduleWidget: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var practiceManager:PracticeManager
    @State private var practice:Practice?
    private let gridSpacing:CGFloat = 16
    private let textSpacing: CGFloat = 10
    
    private let itemHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            List {
                ForEach($practiceManager.practiceSchedule, id:\.id) {step in
                    ScheduleWidgetListing(step: step)
                        .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: deleteStep(_:))
                .onMove(perform: moveStep(from:to:))
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .background(Color("BentoColor"))
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        /// get practice
        .onAppear {
            practice = practiceManager.getPractice()
        }
    }
    
    private func deleteStep(_ indexSet: IndexSet) {
        practiceManager.practiceSchedule.remove(atOffsets: indexSet)
    }
    
    private func moveStep(from source: IndexSet, to destination: Int) {
        practiceManager.practiceSchedule.move(fromOffsets: source, toOffset: destination)
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
