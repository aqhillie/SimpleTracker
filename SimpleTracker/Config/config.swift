//
//  config.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

// UserDefaults
let defaults = UserDefaults.standard

// default values
let defaultObjective: Int = 1
let defaultDifficulty: Int = 0
let defaultItemProgression: Int = 0
let defaultQol: Int = 2
let defaultMapLayout: Int = 1
let defaultCollectibleWallJump: Bool = false

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

var objective: Int = (defaults.object(forKey: "objective") != nil) ? defaults.integer(forKey: "objective") : defaultObjective
var difficulty: Int = (defaults.object(forKey: "difficulty") != nil) ? defaults.integer(forKey: "difficulty") : defaultDifficulty
var itemProgression: Int = (defaults.object(forKey: "itemProgression") != nil) ? defaults.integer(forKey: "itemProgression") : defaultItemProgression
var qol: Int = (defaults.object(forKey: "qol") != nil) ? defaults.integer(forKey: "qol") : defaultQol
var mapLayout: Int = (defaults.object(forKey: "mapLayout") != nil) ? defaults.integer(forKey: "mapLayout") : defaultMapLayout

var collectibleWallJump: Bool = (defaults.object(forKey: "collectibleWallJump") != nil) ? defaults.bool(forKey: "collectibleWallJump") : defaultCollectibleWallJump

// Gets Map Rando Seed Configuration options for right-hand option selectors
var configOptions: [GameOption] = [
    GameOption(key: "objective", title: "Objectives", options: ["None", "Bosses", "Minibosses", "Metroids", "Chozos", "Pirates", "Random"], colors: [0x808080], selection: objective),
    GameOption(key: "difficulty", title: "Difficulty", options: ["Basic", "Medium", "Hard", "Very Hard", "Expert", "Extreme", "Insane"], colors: [0x066815, 0xCBCA02, 0xC20003, 0x5B0012, 0x0766C0, 0x0400C3, 0xC706C9], selection: difficulty),
    GameOption(key: "itemProgression", title: "Item Progression", options: ["Normal", "Tricky", "Challenge", "Desolate"], colors: [0x066815, 0xCBCA02, 0xC20003, 0xC706C9], selection: itemProgression),
    GameOption(key: "qol", title: "Quality of Life", options: ["Off", "Low", "Default", "Max"], colors: [0x5B0012, 0xC20003, 0xCBCA02, 0x066815], selection: qol),
    GameOption(key: "mapLayout", title: "Map Layout", options: ["Vanilla", "Tame", "Wild"], colors: [0x066815, 0xCBCA02, 0xC20003], selection: mapLayout)
]
