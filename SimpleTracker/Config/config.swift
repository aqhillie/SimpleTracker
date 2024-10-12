//
//  config.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

class AppState: ObservableObject {
    
    var objective: Int = max(UserDefaults.standard.integer(forKey: "objective"), 1)
    var difficulty: Int = UserDefaults.standard.integer(forKey: "difficulty")
    var itemProgression: Int = UserDefaults.standard.integer(forKey: "itemProgression")
    var qol: Int = max(UserDefaults.standard.integer(forKey: "qol"), 2)
    var mapLayout: Int = max(UserDefaults.standard.integer(forKey: "mapLayout"), 1)
    var collectibleWallJump: Bool = UserDefaults.standard.bool(forKey: "collectibleWallJump")
    var configOptions: [GameOption] = [] 
    // Boss / Item Icons, respectively
    let bossNames: [String] = ["ridley", "phantoon", "kraid", "draygon"]
    let itemNames: [String] = ["charge", "ice", "wave", "spazer", "plasma", "", "varia", "gravity", "", "grapple", "xray", "", "morph", "bomb", "springball", "screw", "", "", "hijump", "space", "speed", "walljump", "", "", "missile", "super", "powerbomb", "etank", "reservetank", ""]
    
    // Items which have a finite supply and you find packs of
    let consumables: [String] = ["missile", "super", "powerbomb", "etank", "reservetank"]
    
    // Max item packes allowed
    let maxPacks: [String: Int] = [
        "missile": 46,
        "super": 10,
        "powerbomb": 10,
        "etank": 14,
        "reservetank": 4
    ]
    
   
    
    // Gets Map Rando Seed Configuration options for right-hand option selectors
    init() {
        configOptions = [
            GameOption(key: "objective", title: "Objectives", options: ["None", "Bosses", "Minibosses", "Metroids", "Chozos", "Pirates", "Random"], colors: [0x808080], selection: objective),
            GameOption(key: "difficulty", title: "Difficulty", options: ["Basic", "Medium", "Hard", "Very Hard", "Expert", "Extreme", "Insane"], colors: [0x066815, 0xCBCA02, 0xC20003, 0x5B0012, 0x0766C0, 0x0400C3, 0xC706C9], selection: difficulty),
            GameOption(key: "itemProgression", title: "Item Progression", options: ["Normal", "Tricky", "Challenge", "Desolate"], colors: [0x066815, 0xCBCA02, 0xC20003, 0xC706C9], selection: itemProgression),
            GameOption(key: "qol", title: "Quality of Life", options: ["Off", "Low", "Default", "Max"], colors: [0x5B0012, 0xC20003, 0xCBCA02, 0x066815], selection: qol),
            GameOption(key: "mapLayout", title: "Map Layout", options: ["Vanilla", "Tame", "Wild"], colors: [0x066815, 0xCBCA02, 0xC20003], selection: mapLayout)
        ]
    }
}
