//
//  PracticeNotesView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/15/24.
//

import SwiftUI
import SwiftData

struct PracticeNotesView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var practiceManager:PracticeManager
    private let titleSize:CGFloat = 25
    private let gridSpacing:CGFloat = 16
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: gridSpacing * 3) {
                // Schedule
                VStack (alignment: .leading) {
                    HStack (alignment: .bottom) {
                        Text("Schedule")
                            .font(.system(size: titleSize))
                            .fontWeight(.semibold)
                        Spacer()
                        CircleButton(systemName: "plus", isLarge: false) {
                            practiceManager.addNewPracticeStep()
                        }
                    }
                    if practiceManager.practiceSchedule.count == 0 {
                        HStack {
                            Text("Create a schedule to help guide your practice!")
                                .foregroundStyle(Color.gray)
                            Spacer()
                        }
                    } else {
                        ScheduleWidget()
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 1)
                    }
                }
                
                // Goals
                VStack (alignment: .leading) {
                    HStack (alignment: .bottom) {
                        Text("Goals")
                            .font(.system(size: titleSize))
                            .fontWeight(.semibold)
                        Spacer()
                        CircleButton(systemName: "plus", isLarge: false) {
                            practiceManager.addNewPracticeGoal()
                        }
                    }
                    if practiceManager.practiceGoals.count == 0 {
                        HStack {
                            Text("Add some goals for your practice!")
                                .foregroundStyle(Color.gray)
                            Spacer()
                        }
                    } else {
                        GoalWidget()
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 1)
                    }
                }
                
                // Notes
                VStack (alignment: .leading) {
                    Text("Notes")
                        .font(.system(size: titleSize))
                        .fontWeight(.semibold)
                    TextField("Notes", text: $practiceManager.practiceNotes, axis: .vertical)
                        .frame(minHeight: 100, alignment: .topLeading)
                        .padding(gridSpacing)
                        .background(Color("BentoColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: .black.opacity(0.1), radius: 10, y: 1)
                }
            }
            .padding(gridSpacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color("BackgroundColor"))
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
