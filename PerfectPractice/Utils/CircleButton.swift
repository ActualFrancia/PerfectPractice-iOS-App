//
//  CircleButton.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/8/24.
//

import SwiftUI
import SwiftData

struct CircleButton: View {
    var systemName:String
    var isLarge:Bool
    var action: () -> Void
    
    private let buttonSize:CGFloat = 36
    private let padding:CGFloat = 11

    private let largeButtonSize:CGFloat = 50
    private let largePadding:CGFloat = 14

    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
        }
        .padding(isLarge ? largePadding : padding)
        .frame(width: isLarge ? largeButtonSize : buttonSize, height: isLarge ? largeButtonSize : buttonSize)
        .background(Color("BentoColor"))
        .clipShape(Circle())
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
