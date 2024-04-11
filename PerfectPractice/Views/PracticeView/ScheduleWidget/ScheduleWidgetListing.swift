//
//  ScheduleWidgetListing.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/11/24.
//

import SwiftUI

struct ScheduleWidgetListing: View {
    @Binding var step:practiceStep
    
    var body: some View {
        HStack {
            // Todo isCompleted
            Toggle(isOn: $step.isCompleted) {
                Image(systemName: step.isCompleted ? "checkmark.square" : "square")
            }
            .toggleStyle(.button)
            
            // Todo Text
            TextField("Step", text: $step.stepDescription)
            
            Spacer()
            Image(systemName: "line.horizontal.3")
                .foregroundStyle(.gray.opacity(0.5))
        }
    }
}
