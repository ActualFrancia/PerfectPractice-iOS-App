//
//  Item.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
