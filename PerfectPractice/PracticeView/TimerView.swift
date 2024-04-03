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
    @EnvironmentObject var practiceStateManager:PracticeStateManager
    @Binding var practice:Practice
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Timer")
                .font(.headline)
            Text("\(formattedTime(timerManager.elapsedTime))")
            
            switch timerManager.timerState {
            // Timer is Running
            case .running:
                /// Pause Practice
                pauseButton()
                stopButton()
            // Timer is Paused
            case .paused:
                resumeButton()
                stopButton()
            // Timer is Stopped
            case .stopped:
                startButton()
            }
        }        
        .frame(maxWidth: .infinity)
        .background(.ultraThickMaterial)
        .onAppear {
            if (timerManager.timerState == .stopped) {
                timerManager.elapsedTime = 0
            }
        }
    }
    
    // Start Button
    func startButton() -> some View {
        Button(action: {
            timerManager.startTimer()
            practiceStateManager.startPractice()
            practice.timeStart = Date.now
        }) {
            Text("Start Practice Sesson")
        }
    }
    
    // Stop Button
    func stopButton() -> some View {
        Button(action: {
            timerManager.stopTimer()
            practiceStateManager.stopPractice()
        }) {
            Text("Complete Session")
        }
    }
    
    func pauseButton() -> some View {
        Button(action: {
            timerManager.pauseTimer()
        }) {
            Text("Pause")
        }
    }
    
    func resumeButton() -> some View {
        Button(action: {
            timerManager.resumeTimer()
        }) {
            Text("Resume")
        }
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
        .environmentObject(PracticeStateManager())
        .environmentObject(TimerManager())
}
