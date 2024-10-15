// 
//  Option.swift
//  SimpleTracker
//
//  Created by Ryan Ashton on 13/10/2024 at 12:46 PM
//  Copyright © 2024 Ryan Ashton. All rights reserved.
//
    

import SwiftUI

@Observable
class Option: @unchecked Sendable {
    
    let key: String
    let title: String
    let options: [String]
    let colors: [CustomColor]
    let initSelection: Int
    var selection: Int {
        didSet {
            UserDefaults.standard.set(selection, forKey: key)
        }
    }
    
    init(key: String, title: String, options: [String], colors: [CustomColor], selection: Int) {
        self.key = key
        self.title = title
        self.options = options
        self.colors = colors
        self.initSelection = selection
        self.selection = selection
    }
    
    func update(_ selection: Int) {
        self.selection = selection
    }
    
    func reset() {
        selection = initSelection
    }
    
}
