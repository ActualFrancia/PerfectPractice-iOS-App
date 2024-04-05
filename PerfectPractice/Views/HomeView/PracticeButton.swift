//
//  SwipeToPracticeView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI
import SwiftData

struct PracticeButton: View {
    @Binding var selectedView:PrimaryViews
    private let circleSize:CGFloat = 65
    private let iconSize:CGFloat = 25

    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            Button(action: {
                selectedView = .practice
            }) {
                Image(systemName: "music.note")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(Color.blue)
            }
            .frame(width: circleSize, height: circleSize)
            .background(.bar)
            .clipShape(Circle())
            .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity)
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
