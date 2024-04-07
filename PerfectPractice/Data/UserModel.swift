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
    
    init(name: String, pfpData: Data? = nil, instrumentsPlayed: [String]? = nil, defaultInstrument: String, defaultTag: String) {
        self.name = name
        self.pfpData = pfpData
        self.instrumentsPlayed = instrumentsPlayed
        self.defaultInstrument = defaultInstrument
        self.defaultTag = defaultTag
    }
}

