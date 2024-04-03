//
//  ContentView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import SwiftUI
import SwiftData

enum ViewList {
    case home, schedule, profile, settings, about, notifications, practice, notepad, practiceHistory
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var timerManager:TimerManager
    @EnvironmentObject var practiceStateManager:PracticeStateManager
    @Query(sort: \Practice.timeStart, order: .reverse) var practices:[Practice]
    @Query var users:[User]
    @State private var selectedView: ViewList = .practice
    @State private var isShowingSidebar = false

    var body: some View {
        ZStack (alignment: .topLeading) {
            // NavStack
            NavigationStack {
                switch selectedView {
                case .practiceHistory:
                    PracticeHistoryView()
                case .profile:
                    ProfileView()
                default:
                    PracticeView()
                }
            }
            // Sidebar
            Button(action: {
                isShowingSidebar = true
            }) {
                Image(uiImage: UIImage(named: "DefaultPFP")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            
            if isShowingSidebar {
                SidebarView(isShowingSidebar: $isShowingSidebar, selectedView: $selectedView)
            }
        }
        /// Ensures users database never stores more than one user.
        .onChange(of: users) {
            for user in users {
                if user != users.first {
                    print("DEBUG: Excess Users Removed")
                    modelContext.delete(user)
                }
            }
        }
        /// Autosaves time practiced incase of app crash or early closure.
        .onChange(of: timerManager.elapsedTime) {
            if (practiceStateManager.isPracticeStarted) {
                practices.first?.timePracticed = timerManager.elapsedTime
            }
        }
    }
}

#Preview {
    // Testing Container
    var testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self
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
        .environmentObject(PracticeStateManager())
        .environmentObject(TimerManager())
}
