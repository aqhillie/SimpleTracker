//
//  AppearanceModifier.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/7/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct Appearance: ViewModifier {
    var type: IconType
    var isActive: Bool
    
    func body(content: Content) -> some View {
        if type == .boss {
            content
                .saturation(isActive ? 0 : 1)
                .opacity(isActive ? 0.33 : 1)
        } else {
            content
                .saturation(isActive ? 1 : 0)
                .opacity(isActive ? 1 : 0.33)
        }
    }
}
