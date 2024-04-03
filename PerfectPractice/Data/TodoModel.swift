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
    // Todo
    var todo:String = ""
    // Due Date
    var dueDate = Date()
    // Completed
    var isCompleted:Bool = false
    // isPastDue
    //
    
    init(todo: String, dueDate: Date = Date(), isCompleted: Bool) {
        self.todo = todo
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}
