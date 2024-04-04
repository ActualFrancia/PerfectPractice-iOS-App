//
//  EventModel.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import Foundation
import SwiftData

@Model
class Event {
    // Name
    var name:String = ""
    // Date
    var date = Date()
    // Upcomming
    var isUpcoming:Bool = true
    // Repeating
    var isRepeating:Bool = false
    var repeatSchedule:String = "" /// weekly, biweekly, monthly, bimonthly, yearly
    // Tag
    var tagColor:String = "blue"
    
    init(name: String, date: Date = Date(), isUpcoming: Bool, isRepeating: Bool, repeatSchedule: String, tagColor: String) {
        self.name = name
        self.date = date
        self.isUpcoming = isUpcoming
        self.isRepeating = isRepeating
        self.repeatSchedule = repeatSchedule
        self.tagColor = tagColor
    }
}
