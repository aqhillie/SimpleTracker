//
//  hex colors.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/7/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

extension Color {
    static let titleActive = Color(0x373737)
    static let titleInactive = Color(0x2C2C2C)
    static let lightCyan = Color(0x6CE2E8)
    static let medCyan = Color(0x21C3D0)
    
    init(_ hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
