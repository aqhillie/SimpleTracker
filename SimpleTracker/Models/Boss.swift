//
//  Boss.swift
//  SimpleTracker
//
//  Created by Ryan Ashton on 13/10/2024 at 2:03 PM
//  Copyright © 2024 Ryan Ashton. All rights reserved.
//


import SwiftUI

@Observable
class Boss {

    let id = UUID()
    
    private let name: String
    private var deadOrNot: Bool = false {
        didSet {
            UserDefaults.standard.set(deadOrNot, forKey: name)
        }
    }
    
    init(name: String) {
        self.name = name
    }
    
    internal func isDead() -> Bool {
        return deadOrNot
    }
    
    internal func getName() -> String {
        return name 
    }
    
    internal func killToggle() {
        self.deadOrNot.toggle()
    }
    
    internal func reset() {
        self.deadOrNot = false
    }
    
}

extension Boss: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}

extension Boss: Identifiable { }

extension Boss: Equatable {
    static func == (lhs: Boss, rhs: Boss) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
