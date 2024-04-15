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

    private let timerHeight:CGFloat = 300
    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                Spacer()
                // Timer & Timer Controls
                VStack (spacing: gridSpacing) {
                    /// Timer
                    Text("\(isHidingTime ? "••:••" : formattedTimer(practice?.timePracticed ?? 0))")
                        .font(.system(size: 80).monospacedDigit())
                        .fontWeight(.semibold)
                        .frame(height: 80, alignment: .center)
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
                .padding(.top, (practiceManager.practiceSchedule.count != 0) || (practiceManager.practiceGoals.count != 0) ? gridSpacing * 4 : gridSpacing)
                .padding(.bottom, gridSpacing)
                .frame(maxWidth: .infinity)
                
                // Schedule & Goals
                if (practiceManager.practiceSchedule.count != 0) || (practiceManager.practiceGoals.count != 0) {
                    ScrollView(.vertical) {
                        VStack (spacing: gridSpacing) {
                            /// Schedule
                            if (practiceManager.practiceSchedule.count != 0) {
                                VStack (alignment: .leading, spacing: gridSpacing/2) {
                                    Text("Schedule")
                                        .font(.system(size: titleSize))
                                        .fontWeight(.semibold)
                                    ScheduleWidget()
                                        .shadow(color: .black.opacity(0.1), radius: 10, y: 1)
                                }
                            }
                            /// Goals
                            if (practiceManager.practiceGoals.count != 0) {
                                VStack (alignment: .leading, spacing: gridSpacing/2) {
                                    Text("Goals")
                                        .font(.system(size: titleSize))
                                        .fontWeight(.semibold)
                                    GoalWidget()
                                        .shadow(color: .black.opacity(0.1), radius: 10, y: 1)
                                }
                            }
                        }
                        .padding(.top, gridSpacing)
                        .padding(.bottom, 36 + gridSpacing)
                        .padding(.horizontal, gridSpacing)
                    }
                } else {
                    Spacer()
                }
            }
            
            
            
            // Controls Overlay
            VStack {
                // Toolbar
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
                Spacer()
                // Tools
                HStack {
                    Spacer()
                    VStack {
                        // Metronome
                        CircleButton(systemName: "metronome.fill", isLarge: true) {
                            //...
                        }
                        // Tuner
                        CircleButton(systemName: "tuningfork", isLarge: true) {
                            //...
                        }
                        // Notes
                        CircleButton(systemName: "square.and.pencil", isLarge: true) {
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
            PracticeNotesView()
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
