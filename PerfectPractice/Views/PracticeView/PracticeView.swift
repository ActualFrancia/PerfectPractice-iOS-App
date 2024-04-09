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
    @State private var isDetailsPresented: Bool = false

    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    /// pfp button
                    PFPButton()
                    
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
                        Text(Date.now.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
            }
            // Timer
            Text("0:00")
                .font(.system(size: 80))
                .fontWeight(.semibold)
            // Timer Controls
            VStack {
                Spacer()
                HStack {
                    /// start
                    if (!practiceManager.isPracticing) {
                        CircleButton(systemName: "play.fill", isLarge: false) {
                            //...
                        }
                    }
                    /// stop and pause
                    else if (practiceManager.isPracticing) {
                        CircleButton(systemName: "play.fill", isLarge: false) {
                            //...
                        }
                    }

                }
                .padding(.top, 130)
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
        // Practice Details
        .sheet(isPresented: $isDetailsPresented) {
            
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
