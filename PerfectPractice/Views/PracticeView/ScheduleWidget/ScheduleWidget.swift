//
//  ScheduleWidget.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/10/24.
//

import SwiftUI
import SwiftData

struct ScheduleWidget: View {
    @EnvironmentObject var practiceManager:PracticeManager
    private let gridSpacing:CGFloat = 16
    private let textSpacing: CGFloat = 10
    private let rowHeight: CGFloat = 50
    
    @State private var totalRowHeight:CGFloat = 0
    
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
                .frame(height: rowHeight)
            }
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .scrollIndicators(.hidden)
            .background(Color("BentoColor"))
        }
        .frame(height: (CGFloat(practiceManager.practiceSchedule.count) * rowHeight) - 1)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
    
    private func deleteStep(_ indexSet: IndexSet) {
        practiceManager.practiceSchedule.remove(atOffsets: indexSet)
    }
    
    private func moveStep(from source: IndexSet, to destination: Int) {
        practiceManager.practiceSchedule.move(fromOffsets: source, toOffset: destination)
    }
    
    private func rowHeightCalculator(rowHeight: CGFloat) {
        totalRowHeight += rowHeight
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
