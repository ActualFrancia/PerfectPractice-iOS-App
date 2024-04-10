//
//  UpcomingWidget.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/8/24.
//

import SwiftUI
import SwiftData

struct UpcomingWidget: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Upcomming")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("blue").opacity(0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BentoColor"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
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
