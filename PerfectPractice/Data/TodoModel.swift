//
//  TodoModel.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import Foundation
import SwiftData

@Model
class ToDo {
    // Todo Name
    var name:String = ""
    // Due Date
    var dueDate = Date()
    // Completed
    var isCompleted:Bool = false
    // isPastDue
    var isPastDue:Bool = false

    init(name: String, dueDate: Date = Date(), isCompleted: Bool = false, isPastDue: Bool = false) {
        self.name = name
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.isPastDue = isPastDue
    }
}
