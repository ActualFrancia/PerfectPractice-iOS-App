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
    // Location
    var location: String = ""
    // Description
    var eventDescription: String = ""
    // Tag Color
    var tagColor:String = "blue"
    // Favorited
    var isFav:Bool = false
    
    init(name: String, date: Date = (Date.now + 3600), isUpcoming: Bool = true, isRepeating: Bool = false, repeatSchedule: String, location: String, eventDescription: String, tagColor: String, isFav: Bool = false) {
        self.name = name
        self.date = date
        self.isUpcoming = isUpcoming
        self.isRepeating = isRepeating
        self.repeatSchedule = repeatSchedule
        self.location = location
        self.eventDescription = eventDescription
        self.tagColor = tagColor
        self.isFav = isFav
    }
}
