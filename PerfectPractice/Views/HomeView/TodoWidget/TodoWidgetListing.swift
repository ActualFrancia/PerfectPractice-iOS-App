//
//  TodoWidgetListing.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/10/24.
//

import SwiftUI
import SwiftData

struct TodoWidgetListing: View {
    @Bindable var todo:ToDo
    private let textSpacing: CGFloat = 10
    var updateHeader: () -> Void
    
    var body: some View {
        VStack (spacing: textSpacing) {
            HStack (alignment: .center, spacing: textSpacing) {
                // Task Complete
                Toggle(isOn: $todo.isCompleted) {
                    Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                }
                .toggleStyle(.button)
                .frame(width: 25, height: 25, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Task Text
                TextField("Todo Item", text: $todo.name, axis: .vertical)
                    .fontWeight(todo.isCompleted ? .regular : .medium)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Task DueDate
                DatePicker("", selection: $todo.dueDate, in: Date.now..., displayedComponents: .date)
            }
        }
        .listRowInsets(EdgeInsets())
        .onChange(of: todo.isCompleted) {
            updateHeader()
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
        .environmentObject(ThemeManager())
        .environmentObject(SidebarManager())
}
