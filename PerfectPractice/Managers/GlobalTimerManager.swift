//
//  EventTimerManager.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/4/24.
//

import Foundation

class GlobalTimerManager: ObservableObject {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}
