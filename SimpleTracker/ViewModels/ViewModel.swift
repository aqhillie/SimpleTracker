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
#if os(iOS)
import UIKit
#endif

@Observable
class ViewModel {

    let defaultActiveStates: [ItemKey: Bool]
    var collectibleWallJumpMode: Int {
        didSet {
            UserDefaults.standard.set(collectibleWallJumpMode, forKey: "collectibleWallJumpMode")
            updateWallJumpIcons()
        }
    }

    let bosses: [BossKey: Boss]
    let items: [ItemKey: Item]
    var bossMatrix: [[Boss]]
    var itemMatrix: [[Item]]
    
    var objective: Int
    var difficulty: Int
    var itemProgression: Int
    var qualityOfLife: Int
    var mapLayout: Int
    var doors: Int
    var startLocation: Int
    var collectibleWallJump: Bool {
        didSet {
            if (collectibleWallJump) {
                items[safe: .walljump].collected = 0
                updateWallJumpIcons()
            } else {
                items[safe: .walljump].isActive = false
                items[safe: .canwalljump].isActive = false
            }
        }
    }
    
    
    let seedOptionData: [SeedOptionDataType: SeedOption]
    
    #if os(iOS)
    let deviceWidth: CGFloat
    let deviceHeight: CGFloat
    #endif
    
    let bossSize: CGFloat
    let itemSize: CGFloat
    let seedOptionVStackSpacing: CGFloat
    let seedOptionsSpacing: CGFloat
    let seedOptionsWidth: CGFloat
    let seedOptionTitleFontSize: CGFloat
    let seedOptionSelectionFontSize: CGFloat
    let lockedSettingOpacity: CGFloat
    
    #if os(macOS)
    var isWindowActive: Bool
    let rootVStackSpacing: CGFloat
    let rootHStackSpacing: CGFloat
    let bossVerticalSpacing: CGFloat
    let itemGridHorizontalSpacing: CGFloat
    let itemGridVerticalSpacing: CGFloat
    let sixthItemRowBosses: [Item]
    let sixthItemRowOthers: [Item]
    #endif

    var broadcastMode: Bool = false
    
    var localMode: Bool {
        didSet {
            UserDefaults.standard.set(localMode, forKey: "localMode")
        }
    }
          
    init() {
        #if os(iOS)
        self.deviceWidth = UIScreen.main.bounds.width
        self.deviceHeight = UIScreen.main.bounds.height

        self.bossSize = self.deviceWidth * 0.18
        self.itemSize = self.deviceWidth * 0.15
        self.seedOptionsWidth = 280
        self.seedOptionTitleFontSize = 18
        self.seedOptionSelectionFontSize = 22
        self.seedOptionVStackSpacing = 10
        self.seedOptionsSpacing = 10
        #elseif os(macOS)
        self.isWindowActive = true
        self.bossSize = 65
        self.itemSize = 60
        self.seedOptionsWidth = 350
        self.seedOptionTitleFontSize = 18
        self.seedOptionSelectionFontSize = 26
        self.bossVerticalSpacing = 30
        self.rootVStackSpacing = 25
        self.rootHStackSpacing = 25
        self.itemGridHorizontalSpacing = 7
        self.itemGridVerticalSpacing = 3
        self.seedOptionVStackSpacing = 20
        self.seedOptionsSpacing = 10        
        #endif
        self.lockedSettingOpacity = 0.3

        self.defaultActiveStates = [
            .eye: true,
            .phantoon: true,
            // these two items are linked, so no need to set .canwalljump to the same UserDefaults setting,
            // coz setting one will set the other.
            .walljump: false,
            .canwalljump: false
        ]

        // Map Rando Seed Options
        self.objective = 1
        self.difficulty = 0
        self.itemProgression = 0
        self.qualityOfLife = 2
        self.mapLayout = 1
        self.doors = 1
        self.startLocation = 0
        self.collectibleWallJump = false

        // seed option data
        self.seedOptionData = [
            .objectives: SeedOption(title: "Objectives", options: ["None", "Bosses", "Minibosses", "Metroids", "Chozos",  "Pirates", "Random"]),
            .difficulty: SeedOption(title: "Difficulty", options: ["Basic", "Medium", "Hard", "Very Hard", "Expert", "Extreme", "Insane"], colors: [0x066815, 0xCBCA02, 0xC20003, 0x5B0012, 0x0766C0, 0x0400C3, 0xC706C9]),
            .itemProgression: SeedOption(title: "Item Progression", options: ["Normal", "Tricky", "Challenge", "Desolate"], colors: [0x066815, 0xCBCA02, 0xC20003, 0xC706C9]),
            .qualityOfLife: SeedOption(title: "Quality of Life", options: ["Off", "Low", "Default", "Max"], colors: [0x5B0012, 0xC20003, 0xCBCA02, 0x066815]),
            .mapLayout: SeedOption(title: "Map Layout", options: ["Vanilla", "Tame", "Wild"], colors: [0x066815, 0xCBCA02, 0xC20003]),
            .doors: SeedOption(title: "Doors", options: ["Blue", "Ammo", "Beam"], colors: [0x066815, 0xCBCA02, 0xC20003]),
            .startLocation: SeedOption(title: "Start Location", options: ["Ship", "Random", "Escape"], colors: [0x066815, 0xC20003, 0x404040]),
            .collectibleWallJump: SeedOption(title: "Collectible Wall Jump", options: ["Vanilla", "Collectible"], colors: [0x066815, 0x5B0012])
        ]
        
        // misc settings
        self.localMode = UserDefaults.standard.boolWithDefaultValue(forKey: "localMode", defaultValue: false)
        
        // Single place for all Boss instances
        self.bosses = [
            .ridley: Boss(key: .ridley, name: "Ridley", deadImage: "ridleydead"),
            .phantoon: Boss(key: .phantoon, name: "Phantoon", deadImage: "phantoondead"),
            .kraid: Boss(key: .kraid, name: "Kraid", deadImage: "kraiddead"),
            .draygon: Boss(key: .draygon, name: "Draygon", deadImage: "draygondead"),
            .bombtorizo: Boss(key: .bombtorizo, name: "Bomb Torizo", deadImage: "bombtorizodead"),
            .sporespawn: Boss(key: .sporespawn, name: "Spore Spawn", deadImage: "sporespawndead"),
            .crocomire: Boss(key: .crocomire, name: "Crocomire", deadImage: "crocomiredead"),
            .botwoon: Boss(key: .botwoon, name: "Botwoon", deadImage: "botwoondead"),
            .goldentorizo: Boss(key: .goldentorizo, name: "Golden Torizo", deadImage: "goldentorizodead"),
            .metroids1: Boss(key: .metroids1, name: "Metroids 1", deadImage: "metroids1dead"),
            .metroids2: Boss(key: .metroids2, name: "Metroids 2", deadImage: "metroids2dead"),
            .metroids3: Boss(key: .metroids3, name: "Metroids 3", deadImage: "metroids3dead"),
            .metroids4: Boss(key: .metroids4, name: "Metroids 4", deadImage: "metroids4dead"),
            .chozo1: Boss(key: .chozo1, name: "Bowling Alley Chozo", deadImage: "chozo1dead"),
            .chozo2: Boss(key: .chozo2, name: "Chozo Statue 2", deadImage: "chozo2dead"),
            .pirates1: Boss(key: .pirates1, name: "Pirates 1"),
            .pirates2: Boss(key: .pirates2, name: "Pirates 2"),
            .pirates3: Boss(key: .pirates3, name: "Pirates 3"),
            .pirates4: Boss(key: .pirates4, name: "Pirates 4"),
            .random1: Boss(key: .random1, name: "Random 1"),
            .random2: Boss(key: .random2, name: "Random 2"),
            .random3: Boss(key: .random3, name: "Random 3"),
            .random4: Boss(key: .random4, name: "Random 4"),
        ]

        // Single place for all Item instances
        self.items = [
            .walljump: Item(key: .walljump, name: "Wall Jump Boots"),
            .eye: EyeItem(),
            .canwalljump: CanWallJumpItem(),
            .phantoon: PhantoonItem(),
            .charge: Item(key: .charge, name: "Charge Beam"),
            .ice: Item(key: .ice, name: "Ice Beam"),
            .wave: Item(key: .wave, name: "Wave Beam"),
            .spazer: Item(key: .spazer, name: "Spazer"),
            .plasma: Item(key: .plasma, name: "Plasma Beam"),
            .varia: Item(key: .varia, name: "Varia Suit"),
            .gravity: Item(key: .gravity, name: "Gravity Suit"),
            .grapple: Item(key: .grapple, name: "Grapple Beam"),
            .xray: Item(key: .xray, name: "XRay Scope"),
            .morph: Item(key: .morph, name: "Morph Ball"),
            .bomb: Item(key: .bomb, name: "Morph Ball Bombs"),
            .springball: Item(key: .springball, name: "Spring Ball"),
            .screw: Item(key: .screw, name: "Screw Attack"),
            .hijump: Item(key: .hijump, name: "HiJump Boots"),
            .space: Item(key: .space, name: "Space Jump"),
            .speed: Item(key: .speed, name: "Speed Booster"),
            .missile: Item(key: .missile, name: "Missiles", maxValue: 46, multiplier: 5),
            .supers: Item(key: .supers, name: "Super Missiles", maxValue: 10, multiplier: 5),
            .powerbomb: Item(key: .powerbomb, name: "Power Bombs", maxValue: 10, multiplier: 5),
            .etank: Item(key: .etank, name: "Energy Tanks", maxValue: 14),
            .reservetank: Item(key: .reservetank, name: "Reserve Tanks", maxValue: 4)
        ]

        self.collectibleWallJumpMode = UserDefaults.standard.integerWithDefaultValue(forKey: "collectibleWallJumpMode", defaultValue: 1)
        
        // Matrix of game objective > targets
        self.bossMatrix = [
            // none
            [],
            // bosses
            [
                bosses[safe: .ridley],
                bosses[safe: .phantoon],
                bosses[safe: .kraid],
                bosses[safe: .draygon]
            ],
            // minibosses
            [
                bosses[safe: .bombtorizo],
                bosses[safe: .sporespawn],
                bosses[safe: .crocomire],
                bosses[safe: .botwoon],
                bosses[safe: .goldentorizo]
            ],
            // metroids
            [
                bosses[safe: .metroids1],
                bosses[safe: .metroids2],
                bosses[safe: .metroids3],
                bosses[safe: .metroids4]
            ],
            // chozos
            [
                bosses[safe: .chozo1],
                bosses[safe: .chozo2],
                Boss.emptyBoss,
                Boss.emptyBoss
            ],
            // pirates
            [
                bosses[safe: .pirates1],
                bosses[safe: .pirates2],
                bosses[safe: .pirates3],
                bosses[safe: .pirates4]
            ],
            // random
            [
                bosses[safe: .random1],
                bosses[safe: .random2],
                bosses[safe: .random3],
                bosses[safe: .random4]
            ]
        ]
        
        items[safe: .walljump].linkedItem = items[safe: .canwalljump]
        items[safe: .canwalljump].linkedItem = items[safe: .walljump]

        #if os(macOS)
        self.sixthItemRowBosses = [
            Item.emptyItem,
            Item.emptyItem,
            items[safe: .eye],
            items[safe: .canwalljump],
            Item.emptyItem
        ]
        
        self.sixthItemRowOthers = [
            Item.emptyItem,
            items[safe: .eye],
            items[safe: .phantoon],
            items[safe: .canwalljump],
            Item.emptyItem
        ]

        self.itemMatrix = [
            [
                items[safe: .charge],
                items[safe: .ice],
                items[safe: .wave],
                items[safe: .spazer],
                items[safe: .plasma]
            ],
            [
                items[safe: .varia],
                items[safe: .gravity],
                Item.emptyItem,
                items[safe: .grapple],
                items[safe: .xray]
            ],
            [
                items[safe: .morph],
                items[safe: .bomb],
                items[safe: .springball],
                items[safe: .screw],
                Item.emptyItem
            ],
            [
                items[safe: .hijump],
                items[safe: .space],
                items[safe: .speed],
                items[safe: .walljump],
                Item.emptyItem
            ],
            [
                items[safe: .missile],
                items[safe: .supers],
                items[safe: .powerbomb],
                items[safe: .etank],
                items[safe: .reservetank]
            ]
        ]
        #elseif os(iOS)
        self.itemMatrix = [
            [
                items[safe: .charge],
                items[safe: .varia],
                items[safe: .morph],
                items[safe: .hijump],
                items[safe: .missile]
            ],
            [
                items[safe: .ice],
                items[safe: .gravity],
                items[safe: .bomb],
                items[safe: .space],
                items[safe: .supers]
            ],
            [
                items[safe: .wave],
                items[safe: .canwalljump],
                items[safe: .springball],
                items[safe: .speed],
                items[safe: .powerbomb]
            ],
            [
                items[safe: .spazer],
                items[safe: .grapple],
                items[safe: .screw],
                items[safe: .walljump],
                items[safe: .etank]
            ],
            [
                items[safe: .plasma],
                items[safe: .xray],
                items[safe: .eye],
                items[safe: .phantoon],
                items[safe: .reservetank]
            ]
        ]
        #endif
        
        updateWallJumpIcons()
    }
    
    func resetBosses() {
        for key in bosses.keys {
            bosses[safe: key].reset()
        }
    }
    
    func resetItems() {
        for itemRow in itemMatrix {
            for item in itemRow {
                item.reset()
            }
        }
        #if os(macOS)
        for item in sixthItemRowOthers {
            item.reset()
        }
        #endif
    }
    
    func updateBoss(from message: [String: Any]) {
        guard let key = message["key"] as? String,
              let value = message["value"] as? Bool else { return }
        
        bosses[safe: key.toBossKey()]._isDead = value
    }
    
    func updateItem(from message: [String: Any]) {
        print("in update item")
        guard let key = message["key"] as? String,
              let value = message["value"] as? [String: Any] else { return }

        print("passed the guard")
        
        if let amount = value["amount"] {
            items[safe: key.toItemKey()].collected = amount as! Int
        }
        if let isActive = value["isActive"] {
            items[safe: key.toItemKey()].isActive = isActive as! Bool
        }
    }
    
    func updateWallJumpIcons() {
        switch (collectibleWallJumpMode) {
            case 0:
                items[safe: .walljump].isActive = false
                items[safe: .canwalljump].isActive = false
            case 1:
                items[safe: .walljump].isActive = true
                items[safe: .canwalljump].isActive = false
            case 2:
                items[safe: .walljump].isActive = false
                items[safe: .canwalljump].isActive = true
            case 3:
                items[safe: .walljump].isActive = true
                items[safe: .canwalljump].isActive = true
            default:
                return
        }
    }
    
    func saveSeed() {
        let seedData = SeedData.create(from: self)
        seedData.save()
    }
    
    func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}
