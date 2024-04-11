//
//  CapsuleButton.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/9/24.
//
import SwiftUI
import SwiftData

struct CapsuleButton: View {
    var systemName:String
    var text:String
    var action: () -> Void
    
    private let buttonSize:CGFloat = 36
    private let padding:CGFloat = 11
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
            Text(text)
                .fontWeight(.medium)
        }
        .padding(.vertical, padding)
        .padding(.horizontal, padding + 10)
        .frame(height: buttonSize)
        .background(.bar)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 5, y: 1)
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
