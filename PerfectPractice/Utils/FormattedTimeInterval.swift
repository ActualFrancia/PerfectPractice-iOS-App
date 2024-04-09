//
//  FormattedTimeInterval.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/9/24.
//

import Foundation

// Formatted Time
func formattedTime(_ time: TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    
    if hours == 0 {
        return String(format: "%02d:%02d", minutes, seconds)
    } else {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
