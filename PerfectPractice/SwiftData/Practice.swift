//
//  Practice.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import Foundation
import SwiftData

@Model
class Practice {
    // Instrument
    var instrument:String = ""
    // Time
    var timeStart = Date()
    var timeStop = Date()
    // Schedule
    var practiceSchedule: String = "" // [(String:Int:Int)], stored as String for SwiftData Predicate Filters
    // Goals
    var practiceGoals:String = ""   // [(String:Bool)], stored as String for SwiftData Predicate Filters
    // Aura
    var aura:String = auraList[0]
    // Tags
    var tag:String = "" // Colors
    // Notes
    var notes:String = ""
    
    init(instrument: String, timeStart: Date = Date(), timeStop: Date = Date(), practiceSchedule: String, practiceGoals: String, aura: String, tag: String, notes: String) {
        self.instrument = instrument
        self.timeStart = timeStart
        self.timeStop = timeStop
        self.practiceSchedule = practiceSchedule
        self.practiceGoals = practiceGoals
        self.aura = aura
        self.tag = tag
        self.notes = notes
    }
}

// Auras
let auraList: [String] = [
     "neutral",
     "upbeat",
     "serene",
     "focused",
     "satisfying",
     "challenging",
     "mixed",
     "melancholy",
     "bleh"
]

let instrumentData: [String: [String]] = [
    // Voice
    "voice": ["voice"],
    // Winds
    "winds": ["flute",
              "clarinet"],
    // Brass
    "brass": ["trumpet",
              "mello"]
]