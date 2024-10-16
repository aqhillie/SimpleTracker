//
//  AppearanceModifier.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

struct Appearance: ViewModifier {
    var type: IconType
    var isActive: Bool
    
    func body(content: Content) -> some View {
        if type == .boss {
            content
                .saturation(isActive ? 0 : 1)
        } else {
            content
                .saturation(isActive ? 1 : 0)
                .opacity(isActive ? 1 : 0.33)
        }
    }
}
