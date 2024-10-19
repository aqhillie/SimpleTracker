//
//  ViewModel.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/14/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

@Observable
class ViewModel {
    
    let bossSize: CGFloat
    let itemSize: CGFloat
    let rootVStackSpacing: CGFloat
    let rootHStackSpacing: CGFloat
    let bossVerticalSpacing: CGFloat
    let itemGridHorizontalSpacing: CGFloat
    let itemGridVerticalSpacing: CGFloat
    let itemGridRows: Int
    let itemGridColumns: Int
    let seedOptionVStackSpacing: CGFloat
    let seedOptionsSpacing: CGFloat
    let seedOptionsWidth: CGFloat
    let seedOptionTitleFontSize: CGFloat
    let seedOptionSelectionFontSize: CGFloat

    var bosses: [Boss]
    var items: [[Item]]
    var seedOptions: [SeedOption]
    
    var collectibleWallJump: Bool {
        didSet {
            UserDefaults.standard.set(collectibleWallJump, forKey: "collectibleWallJump")
        }
    }
    
    var zebesAwake: Bool {
        didSet {
            UserDefaults.standard.set(zebesAwake, forKey: "zebesAwake")
        }
    }
    
    init() {

        self.bossVerticalSpacing = 30
        self.rootVStackSpacing = 25
        self.rootHStackSpacing = 25
        self.itemGridHorizontalSpacing = 12
        self.itemGridVerticalSpacing = 6
        self.seedOptionVStackSpacing = 20
        self.seedOptionsSpacing = 10

        #if os(iOS)
        self.bossSize = 75
        self.itemSize = 70
        self.seedOptionsWidth = 250
        self.seedOptionTitleFontSize = 18
        self.seedOptionSelectionFontSize = 20
        #else
        self.bossSize = 65
        self.itemSize = 60
        self.seedOptionsWidth = 320
        self.seedOptionTitleFontSize = 18
        self.seedOptionSelectionFontSize = 28
        #endif

        self.itemGridRows = 5
        self.itemGridColumns = 5
        
        self.collectibleWallJump = UserDefaults.standard.boolWithDefaultValue(forKey: "collectibleWallJump", defaultValue: false)
        self.zebesAwake = UserDefaults.standard.boolWithDefaultValue(forKey: "zebesAwake", defaultValue: false)

        self.bosses = [
            Boss(key: "ridley", name: "Ridley"),
            Boss(key: "phantoon", name: "Phantoon"),
            Boss(key: "kraid", name: "Kraid"),
            Boss(key: "draygon", name: "Draygon")
        ]
        
        self.items = [
            [
                Item(key: "charge", name: "Charge Beam"),
                Item(key: "varia", name: "Varia Suit"),
                Item(key: "morph", name: "Morphing Ball"),
                Item(key: "hijump", name: "HiJump Boots"),
                Item(key: "missile", name: "Missiles", maxValue: 46, multiplier: 5)
            ],
            [
                Item(key: "ice", name: "Ice Beam"),
                Item(key: "gravity", name: "Gravity Suit"),
                Item(key: "bomb", name: "Morph Ball Bombs"),
                Item(key: "space", name: "Space Jump"),
                Item(key: "super", name: "Super Missiles", maxValue: 10, multiplier: 5)
            ],
            [
                Item(key: "wave", name: "Wave Beam"),
                EmptyItem(),
                Item(key: "springball", name: "Spring Ball"),
                Item(key: "speed", name: "Speed Booster"),
                Item(key: "powerbomb", name: "Power Bombs", maxValue: 10, multiplier: 5)
            ],
            [
                Item(key: "spazer", name: "Spazer"),
                Item(key: "grapple", name: "Grapple Beam"),
                Item(key: "screw", name: "Screw Attack"),
                Item(key: "walljump", name: "Wall Jump Boots"),
                Item(key: "etank", name: "Energy Tanks", maxValue: 14)
            ],
            [
                Item(key: "plasma", name: "Plasma Beam"),
                Item(key: "xray", name: "XRay Scope"),
                Item(key: "zebesawake", name: "Zebes Awake"),
                EmptyItem(),
                Item(key: "reservetank", name: "Reserve Tanks", maxValue: 4)
            ]
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
                selection: UserDefaults.standard.integerWithDefaultValue(forKey: "objective", defaultValue: 1)
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
                selection: UserDefaults.standard.integerWithDefaultValue(forKey: "difficulty", defaultValue: 0)
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
                selection: UserDefaults.standard.integerWithDefaultValue(forKey: "itemProgression", defaultValue: 0)
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
                selection: UserDefaults.standard.integerWithDefaultValue(forKey: "qualityOfLife", defaultValue: 2)
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
                selection: UserDefaults.standard.integerWithDefaultValue(forKey: "mapLayout", defaultValue: 1)
            )
        ]
        
    }
    
    func resetBosses() {
        for boss in bosses {
            boss.reset()
        }
    }
    
    func resetItems() {
        for itemRow in items {
            for item in itemRow {
                item.reset()
            }
        }
    }
    
    func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}
