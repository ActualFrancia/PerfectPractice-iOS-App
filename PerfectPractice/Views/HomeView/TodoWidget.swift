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
    @Binding var isEditingTodo:ToDo?
    
    var body: some View {
        ScrollView (.vertical) {
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
                // Todo Items
                ForEach(todos) { todo in
                    Divider()
                    HStack (spacing: textSpacing) {
                        // Task Complete
                        Button(action: {
                            todo.isCompleted.toggle()
                            updateTodoHeader()
                        }) {
                            Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15, alignment: .center)
                        }
                        .frame(width: 25)
                        
                        Button(action: {
                            isEditingTodo = todo
                        }) {
                            // Task Text
                            Text(todo.name)
                                .fontWeight(todo.isCompleted ? .regular : .medium)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            
                            // Task DueDate
                            Text("\(todo.dueDate.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits)))")
                                .fontWeight(todo.isCompleted ? .regular : .medium)
                                .frame(width: 65, alignment: .leading)
                        }
                    }
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? Color.gray.opacity(0.8) : (todo.isPastDue ? Color.red : .text))
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, gridSpacing)
                    .background(todo.isCompleted ? Color.clear : (todo.isPastDue ? Color.red.opacity(0.25) : Color.clear))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(10)
        }
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
