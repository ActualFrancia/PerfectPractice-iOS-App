//
//  HelperFunctions.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import Foundation
import SwiftUI
import UIKit

let delimiter = "␟" // Ascii Code 31 (Unit Seperator)


// Time difference between two dates
func dateDifference(from: Date, to: Date) -> (hrs: Int, mins: Int) {
    let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: from, to: to)
    return (hrs: diffComponents.hour ?? 0, mins: diffComponents.minute ?? 0)
}

// PracticeSchedule: String <-> [(String:Bool)]

func stringBoolToString(stepsArray: [(String, Bool)]) -> String {
    var longString:String = ""
    
    // Append tuples to longString
    for step in stepsArray {
        longString += "\(delimiter)\(step.0):\(step.1)"
    }
    
    return longString
}

func stringToStringBool(longString: String) -> [(String, Bool)] {
    // Separate by delimiter
    let separatedArray = longString.components(separatedBy: delimiter)
    
    // Convert to tuples
    var result: [(String, Bool)] = []
    
    for item in separatedArray {
        // Separate each item into tuple components
        let components = item.components(separatedBy: ":")
        // Filter out empty components
        let filteredComponents = components.filter { !$0.isEmpty }
        
        if filteredComponents.count == 2 {
            let stepDescription = filteredComponents[0]
            let achieved = filteredComponents[1] == "true"
            result.append((stepDescription, achieved))
        }
    }
    return result
}

// PracticeGoals: String <-> [(String:Bool)]

func stringIntIntToString(stepsArray: [(String, Int, Int)]) -> String {
    var longString:String = ""
    
    // Append tuples to longString
    for step in stepsArray {
        longString += "\(delimiter)\(step.0):\(step.1):\(step.2)"
    }
    
    return longString
}

func stringToStringIntInt(longString: String) -> [(String, Int, Int)] {
    // Separate by delimiter
    let separatedArray = longString.components(separatedBy: delimiter)
    
    // Convert to tuples
    var result: [(String, Int, Int)] = []
    
    for item in separatedArray {
        // Separate each item into tuple components
        let components = item.components(separatedBy: ":")
        // Filter out empty components
        let filteredComponents = components.filter { !$0.isEmpty }
        
        if filteredComponents.count == 3 {
            let practiceStep = filteredComponents[0]
            let hours = Int(filteredComponents[1]) ?? 0
            let minutes = Int(filteredComponents[2]) ?? 0
            
            result.append((practiceStep, hours, minutes))
        }
    }
    return result
}

// Image extension for Data
extension Image {
    init?(data: Data) {
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
    }
}

// UserPFP or Stock Image
func userPFP(pfpData: Data?) -> Image {
    if let pfpData = pfpData {
        return Image(data: pfpData)!
    } else {
        return Image(systemName: "person.circle")
    }
}
