//
//  HomeView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var selectedView:PrimaryViews

    @State private var isEditingEvent: Event? = nil
    
    @State private var path = NavigationPath()
    private let toolbarHeight:CGFloat = 60
    private let gridSpacing:CGFloat = 16
    
    var body: some View {
        NavigationStack (path: $path) {
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
                                    .font(.system(size: 30))
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
                                Text("Upcoming Events")
                                    .font(.system(size: 30))
                                    .fontWeight(.semibold)
                                Spacer()
                                // Events Listing
                                Button(action: {
                                    selectedView = .eventListing
                                }) {
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(Color.blue)
                                }
                                .padding(12)
                                .background(.white)
                                .clipShape(Circle())
                            }
                            /// Upcoming Events
                            UpcomingEventWidget(isEditingEvent: $isEditingEvent)
                        }
                        
                        // Todo List
                        VStack (alignment: .leading, spacing: gridSpacing) {
                            Text("Todo List")
                                .font(.system(size: 30))
                                .fontWeight(.semibold)
                            Bento {
                                Text("Todo List")
                            }
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
