//
//  DataTransformation.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import Foundation

// Date Subtract Extention
extension Date {
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        /// returns tuple
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}

// Event Days till
func daysHoursMinutesTillEvent(date: Date) -> (time: Int, timeType: String) {
    let interval = date - .now
    if (interval.day != 0) {
        return (time: interval.day!, timeType: interval.day! > 1 ? "days" : "day")
    }
    else if interval.hour != 0 {
        return (time: interval.hour!, timeType: interval.hour! > 1 ? "hours" : "hour")
    }
    else if interval.minute != 0 {
        return (time: interval.minute!, timeType: interval.minute! > 1 ? "minutes" : "minute")
    }
    else {
        return (time: 0, timeType: "")
    }
}

// Practice Schedule & Goals
let unitDelimiter = "␟" // Ascii Code 31 (Unit Seperator)
let recordDelimiter = "␞" // Ascii Code 30 (Record Seperator)

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
        
        if filteredComponents.count == 3 {
            let isCompleted = filteredComponents[0] == "true"
            let stepDescription = filteredComponents[1]
            let timeInterval = Double(filteredComponents[2]) ?? 0
            
            let step:practiceStep = practiceStep(isCompleted: isCompleted, stepDescription: stepDescription, time: timeInterval)
            
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
    
    result = "\(unitDelimiter)\(step.isCompleted)\(recordDelimiter)\(step.stepDescription)\(recordDelimiter)\(step.time)"
    
    return result
}
