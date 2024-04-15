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
    @State private var isNotesPresented:Bool = false
    @State private var practice:Practice?
    @State private var isHidingTime:Bool = false

    private let timerHeight:CGFloat = 220
    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    
    var body: some View {
        ZStack {
            // Schedule & Goals
            ScrollView (showsIndicators: false) {
                VStack (spacing: gridSpacing) {
                    /// Schedule
                    VStack (alignment: .leading, spacing: gridSpacing/2) {
                        Text("Schedule")
                            .font(.system(size: titleSize))
                            .fontWeight(.semibold)
                            .shadow(color: .black.opacity(0.1), radius: 5, y: 1)
                        ScheduleWidget()
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 1)
                    }
                    /// Goals
                    VStack (alignment: .leading, spacing: gridSpacing/2) {
                        Text("Goals")
                            .font(.system(size: titleSize))
                            .fontWeight(.semibold)
                            .shadow(color: .black.opacity(0.1), radius: 5, y: 1)
                        GoalWidget()
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 1)
                    }
                }
                .padding(.top, timerHeight + gridSpacing)
                .padding(.bottom, 36 + gridSpacing)
                .padding(.horizontal, gridSpacing)
            }
            
            // Timer & Timer Controls
            VStack (spacing: 0){
                VStack (spacing: gridSpacing) {
                    /// Timer
                    Text("\(isHidingTime ? "••:••" : formattedTimer(practice?.timePracticed ?? 0))")
                        .font(.system(size: 80).monospacedDigit())
                        .fontWeight(.semibold)
                        .frame(height: 80, alignment: .center)
                        .shadow(color: .black.opacity(0.1), radius: 5, y: 1)
                    /// Timer Controls
                    HStack {
                        Spacer()
                        /// Not Practicing
                        if (!practiceManager.isPracticing) {
                            /// start
                            CapsuleButton(systemName: "play.fill", text: "Start Practicing") {
                                practiceManager.startPractice()
                                modelContext.insert(practice!)
                            }
                        }
                        /// Currently Practicing
                        else if (practiceManager.isPracticing) {
                            /// hide all time
                            CircleButton(systemName: "eye.slash.fill", isLarge: false) {
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
                }
                .padding(.horizontal, gridSpacing)
                .padding(.top, gridSpacing)
                .frame(maxWidth: .infinity, maxHeight: timerHeight)
                .background(.regularMaterial)
                
                Spacer()
            }
            
            // Toolbar
            VStack (spacing: 0) {
                HStack (spacing: gridSpacing) {
                    /// back button
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
                        Text(isHidingTime ? "••:•• ••" : Date.now.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal, gridSpacing)
                Spacer()
            }
            


            // Menu Controls
            VStack {
                Spacer()
                ZStack (alignment: .bottom) {
                    // Tools
                    HStack {
                        Spacer()
                        VStack {
                            // Menu
                            Menu {
                                /// Add Goal
                                Button(action: {
                                    practiceManager.addNewPracticeGoal()
                                }) {
                                    Text("New Goal")
                                    Image(systemName: "plus")
                                }
                                /// Add Schedule Item
                                Button(action: {
                                    practiceManager.addNewPracticeStep()
                                }) {
                                    Text("New Step")
                                    Image(systemName: "plus")
                                }
                            } label: {
                                CircleButton(systemName: "plus", isLarge: true) {
                                    //
                                }
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
                        CapsuleButton(systemName: "square.and.pencil", text: "Notes") {
                            isNotesPresented = true
                        }
                    }
                }
            }
            .padding(.horizontal, gridSpacing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundColor"))
        /// get practice
        .onAppear {
            practice = practiceManager.getPractice()
        }
        /// on practice finish, kick out to home screen to present sheet
        .onChange(of: practiceManager.practiceFinished) {
            selectedView = .home
        }
        // Practice Notes
        .sheet(isPresented: $isNotesPresented) {
            Text("Aura")
            Text("Notes")
            Text("Tag Color?")
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
