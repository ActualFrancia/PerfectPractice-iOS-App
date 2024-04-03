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
    var repeartSchedule:String = "" /// weekly, biweekly, monthly, bimonthly, yearly
    // Days Until
    //
    
    init(name: String, date: Date = Date(), isUpcoming: Bool) {
        self.name = name
        self.date = date
        self.isUpcoming = isUpcoming
    }
}
