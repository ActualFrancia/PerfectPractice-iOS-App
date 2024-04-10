//
//  Practice.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import Foundation
import SwiftData

struct practiceStep: Hashable {
    var isCompleted:Bool
    var stepDescription:String
    var time:TimeInterval
}

@Model
class Practice {
    // Instrument
    var instrumentPracticed:String = ""
    // Time
    var timeStart = Date()
    var timePracticed:TimeInterval = TimeInterval()
    // Schedule
    var practiceScheduleString:String = ""
    var practiceScheduleArray:[practiceStep] {
        return stringToPracticeSteps(string: practiceScheduleString)
    }
    // Goals
    var practiceGoalsString:String = ""
    var practiceGoalsArray:[(String, Bool)] {
        return []
    }
    // Aura
    var mood:String = ""
    // Notes
    var notes:String = ""
    // Tag
    var tag:String = "" ///Color
    
    init(instrumentPracticed: String, timeStart: Date = Date(), timePracticed: TimeInterval, practiceScheduleString: String, practiceGoalsString: String, mood: String, notes: String, tag: String) {
        self.instrumentPracticed = instrumentPracticed
        self.timeStart = timeStart
        self.timePracticed = timePracticed
        self.practiceScheduleString = practiceScheduleString
        self.practiceGoalsString = practiceGoalsString
        self.mood = mood
        self.notes = notes
        self.tag = tag
    }
}
