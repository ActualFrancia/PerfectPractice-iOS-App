//
//  TodoEditView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/7/24.
//

import SwiftUI
import SwiftData

struct TodoEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @Bindable var todo:ToDo
    @State private var showingAlert = false
    private let titleSize:CGFloat = 25
    private let gridSpacing:CGFloat = 16
    
    var body: some View {
        // Edit Todo
        VStack (alignment: .leading, spacing: 0) {
            // Title
            Text("Todo Information")
                .font(.system(size: titleSize))
                .fontWeight(.semibold)
                .padding(.vertical, gridSpacing)
                .padding(.horizontal, gridSpacing)
            // Form
            Form {
                // Name
                Section {
                    TextField("Todo", text: $todo.name, axis: .vertical)
                    Toggle("Completed", isOn: $todo.isCompleted)
                } header: {
                    Text("Todo")
                }
                
                // Due Date
                Section {
                    DatePicker(
                        "Date", selection: $todo.dueDate,
                        displayedComponents: [.date]
                    )
                } header: {
                    Text("Due Date")
                }
                
                // Delete Todo
                Section {
                    Button(action: {
                        deleteTodo(todo: todo)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Delete Todo")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("Delete Todo")
                } footer: {
                    Text("This action cannot be undone.")
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color("BackgroundColor"))
        .onDisappear {
            /// If todo name is empty, default event name
            if todo.name == "" {
                todo.name = "Todo"
            }
            /// if todo date changed, make not past due
            if todo.dueDate < Date.now {
                todo.isPastDue = true
            } else {
                todo.isPastDue = false
            }
        }
    }
    private func deleteTodo(todo: ToDo) {
        modelContext.delete(todo)
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
        .environmentObject(ThemeManager())
        .environmentObject(SidebarManager())
}
