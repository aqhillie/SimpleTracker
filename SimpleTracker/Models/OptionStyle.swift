// 
//  OptionStyle.swift
//  SimpleTracker
//
//  Created by Ryan Ashton on 15/10/2024 at 11:51 AM
//  Copyright © 2024 Ryan Ashton. All rights reserved.
//
    

import SwiftUI

struct OptionStyle: ShapeStyle {
    
    let gameOption: Option
    
    init(_ gameOption: Option) {
        self.gameOption = gameOption
    }
    
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        return getColor()
    }
    
    func getColor() -> Color {
        let idx = gameOption.selection
        let colors = gameOption.colors.map({ $0.rawValue })
        if idx > colors.count - 1 {
            return Color(hex: colors[colors.count - 1])
        } else {
            return Color(hex: colors[idx])
        }
    }
    
    
    
}
