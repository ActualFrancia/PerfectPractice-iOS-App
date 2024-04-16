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
        if isLarge {
            Button(action: {
                action()
            }) {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
            }
            .padding(largePadding)
            .frame(width: largeButtonSize, height:largeButtonSize, alignment: .center)
            .background(.bar)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.1), radius: 5)
        }
        else {
            Button(action: {
                action()
            }) {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
            }
            .padding(padding)
            .frame(width: buttonSize, height: buttonSize)
            .background(Color("BentoColor"))
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.1), radius: 5)
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
