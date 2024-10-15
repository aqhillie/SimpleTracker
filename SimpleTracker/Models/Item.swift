//
//  Item.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/14/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//

import SwiftUI
class Item {
    
    let key: String
    let name: String
    var collected: Int = 0 {
        didSet {
            UserDefaults.standard.set(collected, forKey: "\(collected)_collected")
        }
    }
    let maxValue: Int
    let multiplier: Int
    let isConsumable: Bool
    
    init(key: String, name: String, maxValue: Int = 1, multiplier: Int = 1) {
        self.key = key
        self.name = name
        self.collected = 0
        self.maxValue = maxValue
        self.multiplier = multiplier
        self.isConsumable = (maxValue == 1) ? false : true
    }
    
    func collect() {
        if (isConsumable) {
            if collected < maxValue {
                collected += multiplier
            }
        } else {
            collected += (collected == 0) ? 1 : -1
        }
    }
    
    func getCount() -> Int {
        return collected
    }

    func reset() {
        collected = 0
    }
}
