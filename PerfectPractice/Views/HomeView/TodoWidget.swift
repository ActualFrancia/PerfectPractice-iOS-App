//
//  TodoWidget.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/5/24.
//

import SwiftUI
import SwiftData


struct TodoWidget: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userManager:UserManager
    @State private var completedEvents:Int = 0
    @State private var totalEvents:Int = 0
    private let gridSpacing: CGFloat = 6
    private let textSpacing: CGFloat = 10
    
    var body: some View {
        VStack (spacing: gridSpacing) {
            // Header
            HStack (spacing: textSpacing) {
                // Number
                Text("\(completedEvents)/\(totalEvents)")
                    .font(.system(size: 16.5).monospacedDigit())
                    .fontWeight(.semibold)
                    .fixedSize()
                // Item
                Text("Items")
                    .font(.system(size: 16.5))
                    .fontWeight(.semibold)
                Spacer()
            }
            .foregroundStyle(Color("TextColor"))
            
            // List
            NavigationStack {
                List {
                    ForEach(userManager.todoList.indices, id:\.self) { index in
                        HStack {
                            // IsCompleted
                            Toggle(isOn: $userManager.todoList[index].isCompleted) {
                                Image(systemName: userManager.todoList[index].isCompleted ? "checkmark.square" : "square")
                            }
                            .toggleStyle(.button)
                            
                            // Name
                            TextField("Todo Item", text: $userManager.todoList[index].name)
                        }
                    }
                    //.onDelete(perform:)
                    //.onMove(perform: )
                }
                .listStyle(.plain)
            }
            .frame(height: 500)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BentoColor"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
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
