//
//  User.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import Foundation
import SwiftData

@Model
class User {
    // Profile
    var name:String = ""
    @Attribute(.externalStorage) var pfp:Data?
    // Instruments
    var primaryInstruments:[String]? = [String]()
    var secondaryInstruments:[String]? = [String]()
    var defaultInstrument:String = ""

    init(name: String, pfp: Data? = nil, primaryInstruments: [String]? = nil, secondaryInstruments: [String]? = nil, defaultInstrument: String) {
        self.name = name
        self.pfp = pfp
        self.primaryInstruments = primaryInstruments
        self.secondaryInstruments = secondaryInstruments
        self.defaultInstrument = defaultInstrument
    }
}
