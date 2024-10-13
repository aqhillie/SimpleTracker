//
//  Constants.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/13/24.
//

class AppConstants {
    // Max Consumable Packs
    static let maxMissilePacks: Int = 46
    static let maxSuperPacks: Int = 10
    static let maxPowerBombPacks: Int = 10
    static let maxETanks: Int = 14
    static let maxReserveTanks: Int = 4
    
    // Gets Map Rando Seed Configuration options for right-hand option selectors
    static let configOptions: [GameOption] = [
        GameOption(key: "objective", title: "Objectives", options: ["None", "Bosses", "Minibosses", "Metroids", "Chozos", "Pirates", "Random"], colors: [0x808080], selection: objective),
        GameOption(key: "difficulty", title: "Difficulty", options: ["Basic", "Medium", "Hard", "Very Hard", "Expert", "Extreme", "Insane"], colors: [0x066815, 0xCBCA02, 0xC20003, 0x5B0012, 0x0766C0, 0x0400C3, 0xC706C9], selection: difficulty),
        GameOption(key: "itemProgression", title: "Item Progression", options: ["Normal", "Tricky", "Challenge", "Desolate"], colors: [0x066815, 0xCBCA02, 0xC20003, 0xC706C9], selection: itemProgression),
        GameOption(key: "qol", title: "Quality of Life", options: ["Off", "Low", "Default", "Max"], colors: [0x5B0012, 0xC20003, 0xCBCA02, 0x066815], selection: qol),
        GameOption(key: "mapLayout", title: "Map Layout", options: ["Vanilla", "Tame", "Wild"], colors: [0x066815, 0xCBCA02, 0xC20003], selection: mapLayout)
    ]
}
