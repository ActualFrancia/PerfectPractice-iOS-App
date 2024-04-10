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
    @State private var practiceSchedule:[practiceStep] = []
    private let gridSpacing:CGFloat = 16
    private let textSpacing: CGFloat = 10
    
    var body: some View {
        ScrollView (.vertical) {
            VStack (spacing: gridSpacing) {
                // Schedule Steps
                ForEach(practiceSchedule.indices, id:\.self) { index in
                    HStack {
                        // Task Complete
                        Button(action: {
                            practiceSchedule[index].isCompleted.toggle()
                        }) {
                            Image(systemName: practiceSchedule[index].isCompleted ? "checkmark.square" : "square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15, alignment: .center)
                        }
                        .frame(width: 25)
                        
                        // Description
                        Text("\(practiceSchedule[index].stepDescription)")
                        Spacer()
                        
                        // Time
                        Text("\(practiceSchedule[index].time)")
                    }
                }
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BentoColor"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        /// get practice
        .onAppear {
            practice = practiceManager.getPractice()
            
            // TODO: TESTING
            let practiceStep1 = practiceStep(isCompleted: false, stepDescription: "Warmup", time: 45)
            practice?.practiceScheduleString.append(practiceStepToString(step: practiceStep1))
            
            let practiceStep2 = practiceStep(isCompleted: false, stepDescription: "Lipslurs", time: 150)
            practice?.practiceScheduleString.append(practiceStepToString(step: practiceStep2))
            // TODO: -------
            
        }
        /// populate self.practiceSchedule on change to practice.practiceScheduleString
        .onChange(of: practice?.practiceScheduleString) {
            practiceSchedule = practice?.practiceScheduleArray ?? []
        }
        /// update practice.practiceScheduleString on change to self.practiceSchedule
        .onChange(of: practiceSchedule) {
            practice?.practiceScheduleString = practiceStepArrayToString(stepArray: practiceSchedule)
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
