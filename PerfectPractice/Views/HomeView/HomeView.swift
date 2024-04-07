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
    @Binding var selectedView:PrimaryViews
    
    private let toolbarHeight:CGFloat = 60
    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    
    // Sheets
    @State private var isEditingEvent: Event? = nil
    @State private var isEventListingPresented: Bool = false
    
    var body: some View {
        // Home View
        ZStack {
            // Home View
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading, spacing: gridSpacing) {
                    // Starred Event & Stats
                    VStack (alignment: .leading, spacing: gridSpacing) {
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
                            Bento {
                                Text("Starred Event")
                            }
                            Bento {
                                Text("Stats")
                            }
                        }
                        .frame(height: 250)
                    }
                    
                    // Upcomming Events
                    VStack (alignment: .leading, spacing: gridSpacing) {
                        HStack (alignment: .center) {
                            Text("Events")
                                .font(.system(size: titleSize))
                                .fontWeight(.semibold)
                            Spacer()
                            // Add New Event
                            Button(action: {
                                let newEvent = Event(name: "", isUpcoming: true, isRepeating: false, repeatSchedule: "", location: "", eventDescription: "", tagColor: "")
                                modelContext.insert(newEvent)
                                isEditingEvent = newEvent
                            }) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: titleSize/2, height: titleSize/2)
                                    .foregroundStyle(Color.blue)
                            }
                            .padding(titleSize/2)
                            .background(.white)
                            .clipShape(Circle())
                            // Events Listing
                            Button(action: {
                                isEventListingPresented = true
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: titleSize/2, height: titleSize/2)
                                    .foregroundStyle(Color.blue)
                            }
                            .padding(titleSize/2)
                            .background(.white)
                            .clipShape(Circle())
                        }
                        /// Upcoming Events
                        EventsWidget(isEditingEvent: $isEditingEvent)
                    }
                    
                    // Todo List
                    VStack (alignment: .leading, spacing: gridSpacing) {
                        HStack {
                            Text("Todo List")
                                .font(.system(size: titleSize))
                                .fontWeight(.semibold)
                            Spacer()
                            // Add New Todo item
                            Button(action: {
                                //
                            }) {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: titleSize/2, height: titleSize/2)
                                    .foregroundStyle(Color.blue)
                            }
                            .padding(titleSize/2)
                            .background(.white)
                            .clipShape(Circle())
                            // Todo Listing
                            Button(action: {
                                let newEvent = Event(name: "", isUpcoming: true, isRepeating: false, repeatSchedule: "", location: "", eventDescription: "", tagColor: "")
                                modelContext.insert(newEvent)
                                isEditingEvent = newEvent
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: titleSize/2, height: titleSize/2)
                                    .foregroundStyle(Color.blue)
                            }
                            .padding(titleSize/2)
                            .background(.white)
                            .clipShape(Circle())
                        }
                        TodoWidget()
                            .frame(height: 800)
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
        // Add New Event Sheet
        // ...
        // Todo Listing
        // ..
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
