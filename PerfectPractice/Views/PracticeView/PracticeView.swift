//
//  PracticeView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI
import SwiftData

struct PracticeView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var practiceManager:PracticeManager
    @Query var users:[User]
    @Binding var selectedView:PrimaryViews
    @State private var isDetailsPresented:Bool = false
    @State private var practice:Practice?
    @State private var isHidingTime:Bool = false

    private let toolbarHeight:CGFloat = 60
    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    /// pfp button
                    CircleButton(systemName: "chevron.left", isLarge: false) {
                        selectedView = .home
                    }
                    
                    /// instrument
                    Menu {
                        
                    } label: {
                        Text("Instrument")
                        Image(systemName: "chevron.down")
                    }
                    Spacer()
                    
                    // Date & Time
                    VStack (alignment: .trailing) {
                        Text("\(Date.now.formatted(Date.FormatStyle().weekday(.wide))), \(Date.now.formatted(Date.FormatStyle().month().day()))")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        Text(isHidingTime ? "**:** **" : Date.now.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
            }
            VStack (spacing: 0){
                // Timer
                Text("\(isHidingTime ? "**:**" : formattedTime(practice?.timePracticed ?? 0))")
                    .font(.system(size: 80))
                    .fontWeight(.semibold)
                    .padding(.top, toolbarHeight)
                    .frame(alignment: .center)
                // Timer Controls
                HStack {
                    Spacer()
                    /// Not Practicing
                    if (!practiceManager.isPracticing) {
                        /// start
                        CircleButton(systemName: "play.fill", isLarge: false) {
                            practiceManager.startPractice()
                            modelContext.insert(practice!)
                        }
                    }
                    /// Currently Practicing
                    else if (practiceManager.isPracticing) {
                        /// hide all time
                        CircleButton(systemName: "eye.slash", isLarge: false) {
                            isHidingTime.toggle()
                        }
                        
                        /// timer running
                        if (practiceManager.timerState == .running) {
                            /// pause
                            CircleButton(systemName: "pause.fill", isLarge: false) {
                                practiceManager.pausePractice()
                            }
                        } 
                        /// timer paused
                        else {
                            /// resume
                            CircleButton(systemName: "play.fill", isLarge: false) {
                                practiceManager.resumePractice()
                            }
                        }
                        /// stop
                        CircleButton(systemName: "stop.fill", isLarge: false) {
                            practiceManager.stopPractice()
                        }
                    }
                    Spacer()
                }
                // Schedule & Goals
                ScrollView {
                    /// Schedule
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Schedule")
                            .font(.system(size: titleSize))
                            .fontWeight(.semibold)
                        Bento {
                            Text("HI")
                        }
                        .frame(height: 100)
                    }
                    /// Goals
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Goals")
                            .font(.system(size: titleSize))
                            .fontWeight(.semibold)
                        Bento {
                            Text("HI")
                        }
                        .frame(height: 100)
                    }
                }
            }
            // Menu Controls
            VStack {
                Spacer()
                ZStack (alignment: .bottom) {
                    // Tools
                    HStack {
                        Spacer()
                        VStack {
                            // Add Schedule or Goal
                            CircleButton(systemName: "plus", isLarge: true) {
                                // Menu...
                            }
                            // Metronome
                            CircleButton(systemName: "metronome.fill", isLarge: true) {
                                //...
                            }
                            // Tuner
                            CircleButton(systemName: "tuningfork", isLarge: true) {
                                //...
                            }
                        }
                    }
                    HStack {
                        // Hide
                        CircleButton(systemName: "eye.slash.fill", isLarge: false) {
                           //...
                        }
                        // Practice Details
                        Button(action: {
                            isDetailsPresented = true
                        }) {
                            
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 14)
                                .foregroundStyle(Color.blue)
                            Text("Practice Details")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .padding(10)
                        .background(Color("BentoColor"))
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, gridSpacing)
        .background(Color("BackgroundColor"))
        /// get practice
        .onAppear {
            practice = practiceManager.getPractice()
        }
        /// on practice finish, kick out to home screen to present sheet
        .onChange(of: practiceManager.practiceFinished) {
            selectedView = .home
        }
        // Practice Details
        .sheet(isPresented: $isDetailsPresented) {
            //...
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
