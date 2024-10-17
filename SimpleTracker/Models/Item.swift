//
//  Item.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/14/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//

import SwiftUI

class EmptyItem: Item {
    init() {
        super.init(key: "", name: "")
    }
}

@Observable
class Item: Hashable, Identifiable, Equatable {

    let id = UUID()
    
    let key: String
    let name: String
    var collected: Int
    let maxValue: Int
    let multiplier: Int
    let isConsumable: Bool
    var isActive: Bool
    
    init(key: String, name: String, maxValue: Int = 1, multiplier: Int = 1, isActive: Bool = true) {
        self.key = key
        self.name = name
        self.collected = 0
        self.maxValue = maxValue
        self.multiplier = multiplier
        self.isConsumable = (maxValue == 1) ? false : true
        self.isActive = isActive
    }
    
    func collect() {
        if (isConsumable) {
            if collected < (maxValue * multiplier) {
                collected += multiplier
            }
        } else {
            collected += (collected == 0) ? 1 : -1
        }
    }
    
    func decrease() {
        if (isConsumable && collected > 0) {
            collected -= multiplier
        }
    }
    
    func isCollected() -> Bool {
        return collected > 0
    }
    
    func getCount() -> Int {
        return collected
    }

    func reset() {
        collected = 0
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}
