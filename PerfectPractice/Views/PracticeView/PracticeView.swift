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
    @Query var users:[User]
    @Binding var selectedView:PrimaryViews
    @State private var isDetailsPresented: Bool = false

    private let gridSpacing:CGFloat = 16
    private let titleSize:CGFloat = 25
    
    var body: some View {
        VStack {
            HStack {
                // Home Button
                CircleButton(systemName: "house", isLarge: false) {
                    selectedView = .home
                }
                
                // Instrument
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
            // Timer & Controls
            VStack {
                Text("0:00")
                HStack {
                    
                }
            }
            Spacer()
            // Menu Controls
            HStack {
                // Metronome
                CircleButton(systemName: "metronome", isLarge: true) {
                    //.
                }
                
                // Tuner
                Button(action: {
                    //...
                }) {
                    Image(systemName: "tuningfork")
                        .resizable()
                        .scaledToFill()
                        .frame(width: titleSize/2, height: titleSize/2)
                        .foregroundStyle(Color.blue)
                }
                .padding(titleSize/2)
                .background(Color("BentoColor"))
                .clipShape(Circle())
                
                // Practice Details
                Button(action: {
                    isDetailsPresented = true
                }) {
                    
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFill()
                        .frame(width: titleSize/2, height: titleSize/2)
                        .foregroundStyle(Color.blue)
                    Text("Practice Details")
                }
                .padding(titleSize/2)
                .background(Color("BentoColor"))
                .clipShape(Capsule())

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
