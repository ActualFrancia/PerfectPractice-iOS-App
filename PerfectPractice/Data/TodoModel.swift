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
    // Todo Description
    var todoDescription:String = ""
    // Due Date
    var dueDate = Date()
    // Completed
    var isCompleted:Bool = false
    // isPastDue
    //
    
    init(name: String, todoDescription: String, dueDate: Date = Date(), isCompleted: Bool = false) {
        self.name = name
        self.todoDescription = todoDescription
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}
