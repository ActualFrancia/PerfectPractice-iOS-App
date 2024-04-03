//
//  TimerManager.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/2/24.
//

import Foundation

enum TimerState :String {
    case running
    case paused
    case stopped
}

class TimerManager: ObservableObject {
    @Published var timerState: TimerState = .stopped
    @Published var elapsedTime: TimeInterval = 0
    private var timer: Timer?

    func startTimer() {
        guard timerState != .running else { return }
        timerState = .running
        self.elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
        }
    }

    func stopTimer() {
        timerState = .stopped
        timer?.invalidate()
        timer = nil
    }

    func pauseTimer() {
        guard timerState == .running else { return }
        timerState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func resumeTimer() {
        guard timerState != .running else { return }
        timerState = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
        }
    }
}
