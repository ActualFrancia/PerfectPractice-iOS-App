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
    @Query(sort: \ToDo.dueDate, order:.forward) var todos:[ToDo]
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
                    .fontWeight(.semibold)
                    .fixedSize()
                // Item
                Text("Items")
                    .fontWeight(.semibold)
                Spacer()
                // Due Date
                Text("Due")
                    .fontWeight(.semibold)
                    .frame(width: 65, alignment: .leading)
            }
            .foregroundStyle(Color("TextColor"))
            
            // List
            List {
                ForEach(todos) { todo in
                    TodoWidgetListing(todo: todo) {
                        updateTodoHeader()
                    }
                        .listRowSeparator(.visible)
                }
                .onDelete(perform: deleteItem(_:))
            }
            .listStyle(.plain)
            .frame(height: 500)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BentoColor"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        // TESTING
        .onAppear {
            let todo1 = ToDo(name: "Record Lipslur 3 @ 130BPM", dueDate: Date.now + 8888888888, isCompleted: true)
            let todo2 = ToDo(name: "Practice Beathoven 13th thingy", dueDate: Date.now + 5)
            let todo3 = ToDo(name: "I shidded 3333333333333333333333333\n32323232323232")
            let todo4 = ToDo(name: "meow meow meow")
            
            modelContext.insert(todo1)
            modelContext.insert(todo2)
            modelContext.insert(todo3)
            modelContext.insert(todo4)
        }
        // -------
        .onChange(of: todos) {
            /// update headers
            updateTodoHeader()
            /// check if overdue
        }
    }
    
    private func updateTodoHeader() {
        totalEvents = todos.count
        completedEvents = todos.filter{ $0.isCompleted == true }.count
    }
    
    private func deleteItem(_ indexSet: IndexSet) {
        for i in indexSet {
            let todo = todos[i]
            modelContext.delete(todo)
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
