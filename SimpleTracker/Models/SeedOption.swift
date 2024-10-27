//
//  SeedOption.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/14/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

class SeedOption {
    
    let title: String
    let options: [String]
    let colors: [UInt]
    
    static let empty: SeedOption = SeedOption(title: "", options: [])
    
    init(title: String, options: [String], colors: [UInt] = [0x808080]) {
        self.title = title
        self.options = options
        self.colors = colors
    }
}
