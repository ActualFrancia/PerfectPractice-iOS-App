//
//  HomeView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var practiceManager:PracticeManager
    @Binding var selectedView:PrimaryViews
    
    private let toolbarHeight:CGFloat = 60
    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    
    // Sheets
    @State private var isEditingEvent: Event? = nil
    @State private var isEventListingPresented: Bool = false
    @State private var isEditingTodo: ToDo? = nil
    
    var body: some View {
        // Home View
        ZStack {
            // Home View
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading, spacing: gridSpacing) {
                    // Starred Event & Stats
                    VStack (alignment: .leading, spacing: gridSpacing / 2) {
                        // Title
                        HStack (alignment: .center) {
                            Text("Home")
                                .font(.system(size: titleSize))
                                .fontWeight(.semibold)
                            Spacer()
                            // Date & Daily Quote
                            VStack (alignment: .trailing) {
                                Text("\(Date.now.formatted(Date.FormatStyle().weekday(.wide))), \(Date.now.formatted(Date.FormatStyle().month().day()))")
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.gray)
                                Text("Don't forget to hydrate!")
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(height: titleSize)
                        
                        HStack (spacing: gridSpacing) {
                            UpcomingWidget()
                            Bento {
                                Text("Stats")
                            }
                        }
                        .frame(height: 250)
                    }
                    
                    // Events Widget
                    VStack (alignment: .leading, spacing: gridSpacing / 2) {
                        HStack (alignment: .center) {
                            Text("Events")
                                .font(.system(size: titleSize))
                                .fontWeight(.semibold)
                            Spacer()
                            // Add New Event
                            CircleButton(systemName: "plus", isLarge: false) {
                                let newEvent = Event(name: "", isUpcoming: true, isRepeating: false, repeatSchedule: "", location: "", eventDescription: "", tagColor: "")
                                modelContext.insert(newEvent)
                                isEditingEvent = newEvent
                            }
                            // Events Listing
                            CircleButton(systemName: "chevron.right", isLarge: false) {
                                isEventListingPresented = true
                            }
                        }
                        /// events widget
                        EventsWidget(isEditingEvent: $isEditingEvent)
                    }
                    
                    // Todo List Widget
                    VStack (alignment: .leading, spacing: gridSpacing/2) {
                        HStack (alignment: .center) {
                            Text("Todo List")
                                .font(.system(size: titleSize))
                                .fontWeight(.semibold)
                            Spacer()
                            // Add New Todo item
                            CircleButton(systemName: "plus", isLarge: false) {
                                let newTodo = ToDo(name: "")
                                modelContext.insert(newTodo)
                                isEditingTodo = newTodo
                            }
                        }
                        // Todo Widget
                        TodoWidget(isEditingTodo: $isEditingTodo)
                    }
                }
                .padding(.top, toolbarHeight + gridSpacing)
                .padding(.bottom, (70 + 1) + gridSpacing)
                .padding(.horizontal, gridSpacing)
            }
            // Toolbar
            VStack (alignment: .center) {
                ZStack (alignment: .center) {
                    HStack (alignment: .center, spacing: gridSpacing) {
                        PFPButton()
                        Spacer()
                    }
                    VStack (alignment: .center, spacing: 0) {
                        Text("Perfect")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Text("Practice")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal, gridSpacing)
                .padding(.bottom, gridSpacing)
                .frame(height: toolbarHeight)
                .background(.regularMaterial)
                Spacer()
            }
        }
        .background(Color("BackgroundColor"))
        // Event Edit Sheet
        .sheet(item: $isEditingEvent) { event in
            EventEditView(event: event)
        }
        // Event Listing Sheet
        .sheet(isPresented: $isEventListingPresented) {
                EventListingView()
        }
        // Todo Edit Sheet
        .sheet(item: $isEditingTodo) { todo in
            TodoEditView(todo: todo)
        }
        // Finished Practice Overview
        .sheet(isPresented: $practiceManager.practiceFinished) {
            Text("Finished!")
            // Get from practice databse.
        }
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
