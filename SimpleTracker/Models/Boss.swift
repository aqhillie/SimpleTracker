//
//  Boss.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/14/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

@Observable
class Boss: Hashable, Identifiable, Equatable {
    
    let id = UUID()
    
    private let key: String
    private let name: String?
    private var _isDead: Bool = false

    init(key: String, name: String) {
        self.key = key
        self.name = name
    }
    
    internal func isDead() -> Bool {
        return _isDead
    }
    
    internal func getKey() -> String {
        return key
    }
    
    internal func getName() -> String {
        return name ?? ""
    }
    
    internal func deathToggle() {
        self._isDead.toggle()
    }
    
    internal func reset() {
        self._isDead = false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: Boss, rhs: Boss) -> Bool {
        return lhs.id == rhs.id
    }
}
