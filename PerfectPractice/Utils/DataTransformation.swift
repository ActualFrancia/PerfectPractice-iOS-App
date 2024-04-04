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
