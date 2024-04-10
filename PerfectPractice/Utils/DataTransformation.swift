//
//  DataTransformation.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import Foundation

let unitDelimiter = "␟" // Ascii Code 31 (Unit Seperator)
let recordDelimiter = "␞" // Ascii Code 30 (Record Seperator)

// Practice Schedule & Goals
/// ---------------------------------------------------------------------------------------------------

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

