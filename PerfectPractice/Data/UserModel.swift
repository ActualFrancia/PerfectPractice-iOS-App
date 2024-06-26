//
//  UserModel.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import Foundation
import SwiftData

@Model
class User {
    // Profile
    var name:String = ""
    @Attribute(.externalStorage) var pfpData:Data?
    // Instruments
    var instrumentsPlayed:[String]? = [String]()
    // Defaults
    var defaultInstrument:String = ""
    var defaultTag:String = ""
    // Todo
    var todoList:[String]? = [String]()
    // Date Created
    var dateCreated:Date = Date()
    
    init(name: String, pfpData: Data? = nil, instrumentsPlayed: [String]? = nil, defaultInstrument: String, defaultTag: String, todoList: [String]? = nil) {
        self.name = name
        self.pfpData = pfpData
        self.instrumentsPlayed = instrumentsPlayed
        self.defaultInstrument = defaultInstrument
        self.defaultTag = defaultTag
        self.todoList = todoList
    }
}

