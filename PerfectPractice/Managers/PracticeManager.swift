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

struct practiceStep: Identifiable {
    var id = UUID()
    var isCompleted:Bool
    var stepDescription:String
}

struct practiceGoal: Identifiable {
    var id = UUID()
    var isCompleted:Bool
    var goalDescription:String
}


class PracticeManager: ObservableObject {
    // Information
    @Published var practice: Practice = Practice(instrumentPracticed: "", timePracticed: 0, practiceScheduleString: "", practiceGoalsString: "", mood: "", notes: "", tag: "") {
        didSet {
            /// schedule
            self.practiceSchedule = stringToPracticeSteps(string: practice.practiceScheduleString)
            /// goal
            self.practiceGoals = stringToPracticeGoals(string: practice.practiceGoalsString)
        }
    }
    
    
    @Published var isPracticing:Bool = false
    @Published var practiceFinished:Bool = false
    //Timer
    @Published var timerState: TimerState = .stopped
    private var timer: Timer?
    // Schedule
    @Published var practiceSchedule:[practiceStep] = [] {
        didSet {
            practice.practiceScheduleString = practiceStepArrayToString(stepArray: practiceSchedule)
        }
    }
    // Goal
    @Published var practiceGoals:[practiceGoal] = [] {
        didSet {
            practice.practiceGoalsString = practiceGoalsToString(goalArray: practiceGoals)
        }
    }
    
    // Returns practice
    func getPractice() -> Practice {
        return self.practice
    }
    
    // Starts Practice and returns practice for insertion into database.
    func startPractice() {
        /// practice
        isPracticing = true
        practice.timeStart = Date.now
        /// timer
        timerState = .running
        practice.timePracticed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.practice.timePracticed += 1
         }
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
        /// practice overview presented
        practiceFinished = true
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
    
    // SCHEDULE FUNCTIONS
    // -----------------------------------------------------------------------------------
    func addNewPracticeStep() {
        let newStep = practiceStep(isCompleted: false, stepDescription: "")
        practiceSchedule.append(newStep)
    }
    
    /// String -> [practiceStep]
    func stringToPracticeSteps(string: String) -> [practiceStep] {
        var result:[practiceStep] = []
        
        /// seperate by delmiiter
        let seperatedArray = string.components(separatedBy: unitDelimiter)
        
        for item in seperatedArray {
            /// convert to practiceStep
            let components = item.components(separatedBy: recordDelimiter)
            /// filter out empty components
            let filteredComponents = components.filter { !$0.isEmpty }
            
            if filteredComponents.count == 2 {
                let isCompleted = filteredComponents[0] == "true"
                let stepDescription = filteredComponents[1]
                
                let step:practiceStep = practiceStep(isCompleted: isCompleted, stepDescription: stepDescription)
                
                result.append(step)
            }
        }
        return result
    }

    /// [practiceStep] -> String
    func practiceStepArrayToString(stepArray: [practiceStep]) -> String {
        var result = ""
        
        for step in stepArray {
            result.append(practiceStepToString(step: step))
        }
        
        return result
    }

    /// practiceStep -> String
    func practiceStepToString(step: practiceStep) -> String {
        var result = ""
        
        result = "\(unitDelimiter)\(step.isCompleted)\(recordDelimiter)\(step.stepDescription)"
        
        return result
    }

    // GOAL FUNCTIONS
    // -----------------------------------------------------------------------------------
    func addNewPracticeGoal() {
        let newGoal = practiceGoal(isCompleted: false, goalDescription: "")
        practiceGoals.append(newGoal)
    }
    
    /// String -> [practiceGoal]
    func stringToPracticeGoals(string: String) -> [practiceGoal] {
        var result:[practiceGoal] = []
        
        /// seperate by delmiiter
        let seperatedArray = string.components(separatedBy: unitDelimiter)
        
        for item in seperatedArray {
            /// convert to practiceStep
            let components = item.components(separatedBy: recordDelimiter)
            /// filter out empty components
            let filteredComponents = components.filter { !$0.isEmpty }
            
            if filteredComponents.count == 2 {
                let isCompleted = filteredComponents[0] == "true"
                let stepDescription = filteredComponents[1]
                
                let goal:practiceGoal = practiceGoal(isCompleted: isCompleted, goalDescription: stepDescription)
                
                result.append(goal)
            }
        }
        return result
    }

    /// [practiceGoal] -> String
    func practiceGoalsToString(goalArray: [practiceGoal]) -> String {
        var result = ""
        
        for goal in goalArray {
            result.append(practiceGoalToString(goal: goal))
        }
        
        return result
    }

    /// practiceGoal -> String
    func practiceGoalToString(goal: practiceGoal) -> String {
        var result = ""
        
        result = "\(unitDelimiter)\(goal.isCompleted)\(recordDelimiter)\(goal.goalDescription)"
        
        return result
    }
}
