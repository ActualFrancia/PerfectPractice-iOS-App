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
    private let titleSize:CGFloat = 25
    
    @Query var users:[User]
    
    var body: some View {
        VStack (alignment: .leading, spacing: gridSpacing/2) {
            // Title
            HStack (alignment: .center) {
                Text("Todo List")
                    .font(.system(size: titleSize))
                    .fontWeight(.semibold)
                Spacer()
                // Add New Todo item
                CircleButton(systemName: "plus", isLarge: false) {
                    userManager.addNewTodo()
                }
            }
            
            // Widget
            VStack (spacing: gridSpacing) {
                // List
                NavigationStack {
                    List {
                        ForEach($userManager.todoList, id:\.id) { todo in
                            TodoWidgetListing(todo: todo)
                                .listRowInsets(EdgeInsets())
                        }
                        .onDelete(perform: deleteTodo(_:))
                        .onMove(perform: moveTodo(from:to:))
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .listRowBackground(Color.clear)
                    .background(Color("BentoColor"))
                    .toolbar {
                        /// header
                        ToolbarItem(placement: .topBarLeading) {
                            HStack {
                                Text("\(completedEvents)/\(totalEvents)")
                                    .font(.system(size: 16.5).monospacedDigit())
                                    .fontWeight(.semibold)
                                    .fixedSize()
                                // Item
                                Text("Items")
                                    .font(.system(size: 16.5))
                                    .fontWeight(.semibold)
                            }
                        }
                        /// edit button
                        ToolbarItem(placement: .topBarTrailing)  {
                            EditButton()
                        }
                    }
                }
                .frame(height: 500)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
    }
    
    func deleteTodo(_ indexSet: IndexSet) {
        userManager.todoList.remove(atOffsets: indexSet)
    }
    
    func moveTodo(from source: IndexSet, to destination: Int) {
        userManager.todoList.move(fromOffsets: source, toOffset: destination)
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
