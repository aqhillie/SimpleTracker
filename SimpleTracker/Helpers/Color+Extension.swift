//
//  hex colors.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

extension Color {
    
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
    
}
