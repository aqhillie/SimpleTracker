//
//  Item.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/14/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

class EmptyItem: Item {
    init() {
        super.init(key: .empty, name: "")
    }
}

class EyeItem: Item {
    init(id: UUID = UUID()) {
        super.init(id: id, key: .eye, name: "Planet Awake", offImage: "eyeoff", saveActiveState: true)
        self.collected = 1
    }
    
    override func reset() {
        collected = 1
    }
}

class PhantoonItem: Item {
    init() {
        super.init(key: .phantoon, name: "Phantoon", offImage: "phantoondead", saveActiveState: true)
        self.collected = 1
    }
    
    override func reset() {
        collected = 1
    }
}

class CanWallJumpItem: Item {
    init() {
        super.init(key: .canwalljump, name: "Can Wall Jump", offImage: "cannotwalljump", darkenImage: false, saveActiveState: true)
        self.collected = UserDefaults.standard.boolWithDefaultValue(forKey: "collectibleWallJump", defaultValue: false) ? 0 : 1
    }
}

@Observable
class Item: Hashable, Identifiable, Equatable {
    static let emptyItem = EmptyItem()
    
    let id: UUID
    
    let key: ItemKey
    let name: String
    let offImage: String
    let saveActiveState: Bool
    let darkenImage: Bool
    var collected: Int {
        didSet {
            if (collected != oldValue) {
                linkedItem?.collected = collected
            }
       }
    }
    let maxValue: Int
    let multiplier: Int
    let isConsumable: Bool
    var isActive: Bool {
        didSet {
            if (saveActiveState) {
                UserDefaults.standard.set(isActive, forKey: "\(key.toString())_isActive")
            }
        }
    }
    var linkedItem: Item?
    
    init(id: UUID = UUID(), key: ItemKey, name: String, offImage: String = "", darkenImage: Bool = true, saveActiveState: Bool? = nil, maxValue: Int = 1, multiplier: Int = 1, isActive: Bool? = nil, linkedItem: Item? = nil) {
        self.id = id
        self.key = key
        self.name = name
        self.offImage = offImage
        self.darkenImage = darkenImage
        self.saveActiveState = saveActiveState ?? false
        self.collected = 0
        self.maxValue = maxValue
        self.multiplier = multiplier
        self.isConsumable = (maxValue == 1) ? false : true
        self.isActive = isActive ?? UserDefaults.standard.boolWithDefaultValue(forKey: key.toString(), defaultValue: true)
        self.linkedItem = linkedItem
    }
    
    internal func getKey() -> ItemKey {
        return key
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
