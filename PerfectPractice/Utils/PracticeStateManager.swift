//
//  PracticeStateManager.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/2/24.
//

import Foundation

class PracticeStateManager: ObservableObject {
    @Published var isPracticeStarted = false
    
    func startPractice() {
        isPracticeStarted = true
    }
    
    func stopPractice() {
        isPracticeStarted = false
    }
}
