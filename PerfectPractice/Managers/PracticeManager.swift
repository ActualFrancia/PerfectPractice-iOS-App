//
//  PracticeManager.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import Foundation

enum TimerState:String {
    case running
    case paused
    case stopped
}

class PracticeManager: ObservableObject {
    // Information
    @Published var practice: Practice = Practice(instrumentPracticed: "", timePracticed: 0, practiceScheduleString: "", practiceGoalsString: "", mood: "", notes: "", tag: "")
    @Published var isPracticing:Bool = false
    //Timer
    @Published var timerState: TimerState = .stopped
    private var timer: Timer?
    
    // Starts Practice and returns practice for insertion into database.
    func startPractice() -> Practice {
        /// practice
        isPracticing = true
        practice.timeStart = Date.now
        /// timer
        timerState = .running
        practice.timePracticed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.practice.timePracticed += 1
         }
        /// return practice
        return self.practice
    }
    
    // Pause Practice
    func pausePractice() {
        /// timer
        timerState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    // Resume Practice
    func resumePractice() {
        /// timer
        timerState = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.practice.timePracticed += 1
         }
    }
    
    // Stops Practice
    func stopPractice() {
        /// practice
        isPracticing = false
        /// timer
        timerState = .stopped
        timer?.invalidate()
        timer = nil
        /// create new var to prevent accidental changes
        self.newPractice()
    }
    
    // Creates new practice var
    func newPractice() {
        practice = Practice(instrumentPracticed: "", timePracticed: 0, practiceScheduleString: "", practiceGoalsString: "", mood: "", notes: "", tag: "")
    }
    
    // sets intrumentPracticed
    func setIntrumentPracticed(instrument:String) {
        practice.instrumentPracticed = instrument
    }
}
