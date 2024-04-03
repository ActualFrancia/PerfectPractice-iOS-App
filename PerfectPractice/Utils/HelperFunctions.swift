//
//  HelperFunctions.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import Foundation
import SwiftUI

// Image extension for Data
extension Image {
    init?(data: Data) {
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
    }
}

// Image Circle Style
func pfpCircle(pfpData: Data?) -> some View {
    let pfpImage:Image
    
    if let pfpData = pfpData {
        pfpImage = Image(data: pfpData)!
    } else {
        pfpImage = Image("DefaultPFP")
    }
    
    return pfpImage
        .resizable()
        .scaledToFill()
        .frame(width: 50, height: 50)
        .clipShape(Circle())
}
