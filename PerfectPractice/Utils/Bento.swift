//
//  BentoView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI

struct Bento<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color("BentoColor"))
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

