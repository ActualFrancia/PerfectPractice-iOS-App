//
//  TimerView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/2/24.
//

import SwiftUI
import SwiftData

struct TimerView: View {
    @EnvironmentObject var timerManager:TimerManager
    @Binding var practice:Practice
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Timer")
                .font(.headline)
            Text("\(timerManager.elapsedTime)")
            switch timerManager.timerState {
            case .running:
                Button(action: {
                    timerManager.pauseTimer()
                }) {
                    Text("Pause")
                }
                Button(action: {
                    timerManager.stopTimer()
                }) {
                    Text("Complete Session")
                }
            case .paused:
                Button(action: {
                    timerManager.resumeTimer()
                }) {
                    Text("Resume")
                }
                Button(action: {
                    timerManager.stopTimer()
                }) {
                    Text("Complete Session")
                }
            case .stopped:
                Button(action: {
                    timerManager.startTimer()
                }) {
                    Text("Start Practice Sesson")
                }
            }
        }
        .background(.ultraThickMaterial)
    }
    
    // Formatted Time
    private func formattedTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
        .environmentObject(TimerManager())
}
