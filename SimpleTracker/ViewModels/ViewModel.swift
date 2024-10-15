//
//  ViewModel.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/14/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//

import SwiftUI

@Observable
class ViewModel {
    
    let bossSize: CGFloat
    let itemSize: CGFloat
    let itemGridHorizontalSpacing: CGFloat
    let itemGridVerticalSpacing: CGFloat

    var bosses: [Boss]
    var items: [Item?]
    var seedOptions: [SeedOption]
    
    init() {
        self.bossSize = 65
        self.itemSize = 60
        self.itemGridHorizontalSpacing = 12
        self.itemGridVerticalSpacing = 4

        self.bosses = [
            // Even though name is optional I still get this error if I don't supply it here:
            // Missing argument for parameter 'name' in call
            Boss(key: "ridley", name: "Ridley"),
            Boss(key: "phantoon", name: "Phantoon"),
            Boss(key: "kraid", name: "Kraid"),
            Boss(key: "draygon", name: "Draygon")
        ]
        
        self.items = [
            Item(key: "charge", name: "Charge Beam"),
            Item(key: "varia", name: "Varia Suit"),
            Item(key: "morph", name: "Morphing Ball"),
            Item(key: "hijump", name: "HiJump Boots"),
            Item(key: "missile", name: "Missiles", maxValue: 46, multiplier: 5),
            Item(key: "ice", name: "Ice Beam"),
            Item(key: "gravity", name: "Gravity Suit"),
            Item(key: "bomb", name: "Morph Ball Bombs"),
            Item(key: "space", name: "Space Jump"),
            Item(key: "super", name: "Super Missiles", maxValue: 10, multiplier: 5),
            Item(key: "wave", name: "Wave Beam"),
            nil,
            Item(key: "springball", name: "Spring Ball"),
            Item(key: "speed", name: "Speed Booster"),
            Item(key: "powerbomb", name: "Power Bombs", maxValue: 10, multiplier: 5),
            Item(key: "spazer", name: "Spazer"),
            Item(key: "grapple", name: "Grapple Beam"),
            Item(key: "screw", name: "Screw Attack"),
            Item(key: "walljump", name: "Wall Jump Boots"),
            Item(key: "etank", name: "Energy Tanks"),
            Item(key: "plasma", name: "Plasma Beam"),
            Item(key: "xray", name: "XRay Scope"),
            nil,
            nil,
            Item(key: "reservetank", name: "Reserve Tanks")
        ]
        
        self.seedOptions = [
            SeedOption(
                key: "objective",
                title: "Objectives",
                options: ["None",
                          "Bosses",
                          "Minibosses",
                          "Metroids",
                          "Chozos",
                          "Pirates",
                          "Random"],
               selection: 1
            ),
            SeedOption(
                key: "difficulty",
                title: "Difficulty",
                options: ["Basic",
                          "Medium",
                          "Hard",
                          "Very Hard",
                          "Expert",
                          "Extreme",
                          "Insane"],
                colors: [0x066815,
                         0xCBCA02,
                         0xC20003,
                         0x5B0012,
                         0x0766C0,
                         0x0400C3,
                         0xC706C9],
                selection: 0
            ),
            SeedOption(
                key: "itemProgression",
                title: "Item Progression",
                options: ["Normal",
                          "Tricky",
                          "Challenge",
                          "Desolate"],
                colors: [0x066815,
                         0xCBCA02,
                         0xC20003,
                         0xC706C9],
                selection: 0
            ),
            SeedOption(
                key: "qualityOfLife",
                title: "Quality of Life",
                options: ["Off",
                          "Low",
                          "Default",
                          "Max"],
                colors: [0x5B0012,
                         0xC20003,
                         0xCBCA02,
                         0x066815],
                selection: 2
            ),
            SeedOption(
                key: "mapLayout",
                title: "Map Layout",
                options: ["Vanilla",
                          "Tame",
                          "Wild"],
                colors: [0x066815,
                         0xCBCA02,
                         0xC20003],
                selection: 1
            ),
            SeedOption(
                key: "collectibleWallJump",
                title: "Collectible Wall Jump",
                options: ["Vanilla", "Collectible"],
                selection: 0,
                visible: false
            )
        ]
        
    }
    
    func resetBosses() {
        for boss in bosses {
            boss.reset()
        }
    }
    
    func resetItems() {
        for item in items {
            item?.reset()
        }
    }
    
    func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}
