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
    private let toolbarHeight:CGFloat = 55
    private let gridSpacing:CGFloat = 10
    
    var body: some View {
        // Home View
        ZStack {
            // Home
            ScrollView (showsIndicators: false) {
                VStack (spacing: gridSpacing) {
                    HStack (spacing: gridSpacing) {
                        Bento {
                            Text("Starred Event")
                        }
                        VStack {
                            Bento {
                                Text("Hi Gino!")
                            }
                            .frame(height: 50)
                            Bento {
                                Text("Stats")
                            }
                        }
                    }
                    .frame(height: 220)
                    HStack (spacing: gridSpacing) {
                        UpcomingEventWidget()
                        Button(action: {
                            selectedView = .eventListing
                        }) {
                            Image(systemName: "chevron.right")
                                .frame(maxHeight: .infinity)
                                .padding()
                                .background(.ultraThickMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                    }
                    .frame(height: 110)
                    Bento {
                        Text("Todo List")
                    }
                    .frame(height: 800)
                }
                .padding(.top, toolbarHeight + gridSpacing)
                .padding(.bottom, (70 + 1) + gridSpacing)
                .padding(.horizontal, gridSpacing)
            }
            // Toolbar
            VStack (spacing: 0) {
                HStack {
                    Text("Perfect Practice")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity, maxHeight: toolbarHeight)
                .padding(0)
                .background(.bar)
                
                Rectangle()
                    .padding(0)
                    .frame(height: 0.2)
                    .foregroundStyle(.gray.opacity(0.3))
                Spacer()
            }
        }
    }
}

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
}
