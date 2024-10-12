//
//  config.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

@Observable
class AppState: Identifiable {
    
    var objective: Int = max(UserDefaults.standard.integer(forKey: "objective"), 1)
    var difficulty: Int = UserDefaults.standard.integer(forKey: "difficulty")
    var itemProgression: Int = UserDefaults.standard.integer(forKey: "itemProgression")
    var qol: Int = max(UserDefaults.standard.integer(forKey: "qol"), 2)
    var mapLayout: Int = max(UserDefaults.standard.integer(forKey: "mapLayout"), 1)
    var collectibleWallJump: Bool = UserDefaults.standard.bool(forKey: "collectibleWallJump")
    var configOptions: [GameOption] = [] 
    // Boss / Item Icons, respectively
    var bossNames: [String] = ["ridley", "phantoon", "kraid", "draygon"]
    let itemNames: [String] = ["charge", "ice", "wave", "spazer", "plasma", "", "varia", "gravity", "", "grapple", "xray", "", "morph", "bomb", "springball", "screw", "", "", "hijump", "space", "speed", "walljump", "", "", "missile", "super", "powerbomb", "etank", "reservetank", ""]
    
    // Items which have a finite supply and you find packs of
    let consumables: [String] = ["missile", "super", "powerbomb", "etank", "reservetank"]
    
    
    var items: [Item]
   
    func resetItems() {
        for item in items {
            item.reset()
        }
    }
    
    // Gets Map Rando Seed Configuration options for right-hand option selectors
    init() {
        
        items = [
            Item(name: "charge"),
            Item(name: "ice"),
            Item(name: "wave"),
            Item(name: "spazer"),
            Item(name: "plasma"),
            Item(name: ""),
            Item(name: "varia"),
            Item(name: "gravity"),
            Item(name: ""),
            Item(name: "grapple"),
            Item(name: "xray"),
            Item(name: ""),
            Item(name: "morph"),
            Item(name: "bomb"),
            Item(name: "springball"),
            Item(name: "screw"),
            Item(name: ""),
            Item(name: ""),
            Item(name: "hijump"),
            Item(name: "space"),
            Item(name: "speed"),
            Item(name: "walljump"),
            Item(name: ""),
            Item(name: ""),
            Item(name: "missile", maxValue: 46, multiplier: 5),
            Item(name: "super", maxValue: 10, multiplier: 5),
            Item(name: "powerbomb", maxValue: 10, multiplier: 5),
            Item(name: "etank", maxValue: 14),
            Item(name: "reservetank", maxValue: 4),
            Item(name: "")
            
        ]
        
        configOptions = [
            GameOption(key: "objective", title: "Objectives", options: ["None", "Bosses", "Minibosses", "Metroids", "Chozos", "Pirates", "Random"], colors: [0x808080], selection: objective),
            GameOption(key: "difficulty", title: "Difficulty", options: ["Basic", "Medium", "Hard", "Very Hard", "Expert", "Extreme", "Insane"], colors: [0x066815, 0xCBCA02, 0xC20003, 0x5B0012, 0x0766C0, 0x0400C3, 0xC706C9], selection: difficulty),
            GameOption(key: "itemProgression", title: "Item Progression", options: ["Normal", "Tricky", "Challenge", "Desolate"], colors: [0x066815, 0xCBCA02, 0xC20003, 0xC706C9], selection: itemProgression),
            GameOption(key: "qol", title: "Quality of Life", options: ["Off", "Low", "Default", "Max"], colors: [0x5B0012, 0xC20003, 0xCBCA02, 0x066815], selection: qol),
            GameOption(key: "mapLayout", title: "Map Layout", options: ["Vanilla", "Tame", "Wild"], colors: [0x066815, 0xCBCA02, 0xC20003], selection: mapLayout)
        ]
        
    }
    
    func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
    
}

// Max item packes allowed
let maxPacks: [String: Int] = [
    "missile": 46,
    "super": 10,
    "powerbomb": 10,
    "etank": 14,
    "reservetank": 4
]

@Observable
class Item {
    
    let name: String
    var collection: Int = 0 {
        didSet {
            UserDefaults.standard.set(collection, forKey: name)
            print("\(name): \(collection)")
        }
    }
    var maxValue: Int = .max
    let multiplier: Int
    let isConsumable: Bool
    
    init(name: String, maxValue: Int = 1, multiplier: Int = 1) {
        self.name = name
        self.collection = UserDefaults.standard.integer(forKey: name)
        self.maxValue = maxValue
        self.multiplier = multiplier
        self.isConsumable = (maxValue == 1 ? false : true )
        
    }
    
    func collect() {
        switch isConsumable {
            case true:
                if collection < maxValue {
                    collection += multiplier
                }
            case false:
                if collection == 0 {
                    collection += 1
                } else {
                    collection -= 1
                }
        }
    }
    
    func getCollection() -> Int {
        return collection
    }
    
    func reset() {
        collection = 0
    }
    
}
