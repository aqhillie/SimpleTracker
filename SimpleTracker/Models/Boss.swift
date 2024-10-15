//
//  Boss.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/14/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//

import SwiftUI

@Observable
class Boss: Hashable, Identifiable, Equatable {
    
    let id = UUID()
    
    private let key: String
    private let name: String?
    private var _isDead: Bool = false

    /*
     * The default bosses are all one word names, but if I ever decide to say display icons for
     * other objectives like minibosses then there's bosses like "Spore Spawn" and "Bomb Torizo."
     * I added the name separate from the key in case I want to do some accessibility or maybe
     * different themes, I dunno. :P
     */
    init(key: String, name: String?) {
        self.key = key
        self.name = name ?? key.capitalized
    }
    
    internal func isDead() -> Bool {
        return _isDead
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
