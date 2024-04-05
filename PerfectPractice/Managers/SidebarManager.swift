//
//  SidebarManager.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/5/24.
//

import Foundation

class SidebarManager: ObservableObject {
    @Published var isShowing:Bool = false
    
    func showSidebar() {
        isShowing = true
    }
    
    func hideSidebar() {
        isShowing = false
    }
}
