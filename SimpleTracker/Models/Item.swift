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
    @Environment(ViewModel.self) private var viewModel

    let id = UUID()
    
    let key: String
    let name: String
    var collected: Int
    let maxValue: Int
    let multiplier: Int
    let isConsumable: Bool
    var isActive: Bool {
        switch(key) {
            case "walljump":
            return UserDefaults.standard.integer(forKey: "collectibleWallJump") == 1
            default:
                return true
        }
    }
    
    init(key: String, name: String, maxValue: Int = 1, multiplier: Int = 1) {
        self.key = key
        self.name = name
        self.collected = 0
        self.maxValue = maxValue
        self.multiplier = multiplier
        self.isConsumable = (maxValue == 1) ? false : true
    }
    
    func collect() {
        print("collecting")
        if (isConsumable) {
            print("consumable")
            if collected < maxValue {
                collected += multiplier
            }
        } else {
            print("not consumable")
            collected += (collected == 0) ? 1 : -1
        }
        print(getCount())
    }
    
    func decrease() {
        if (isConsumable && collected > 0) {
            collected -= 1
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
}
