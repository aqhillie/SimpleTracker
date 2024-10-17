//
//  SeedOption.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/14/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//

import SwiftUI

@Observable
class SeedOption {
    
    let key: String
    let title: String
    let options: [String]
    let colors: [UInt]
    var selection: Int {
        didSet {
            UserDefaults.standard.set(selection, forKey: key)
        }
    }
    var visible: Bool {
        didSet {
            UserDefaults.standard.set(visible, forKey: "\(key)_visible")
        }
    }
    
    init(key: String, title: String, options: [String], colors: [UInt] = [0x808080], selection: Int, visible: Bool = true) {
        self.key = key
        self.title = title
        self.options = options
        self.colors = colors
        self.selection = selection
        self.visible = visible
    }
    
    func isVisible() -> Bool {
        return visible
    }
    
    func toggleVisible() {
        visible.toggle()
    }
    
    func update(_ selection:Int) {
        self.selection = selection
    }
}
