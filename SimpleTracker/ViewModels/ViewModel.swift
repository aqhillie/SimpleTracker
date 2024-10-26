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
    var collectibleWallJumpMode: Int

    let bosses: [BossKey: Boss]
    let items: [ItemKey: Item]
    var bossMatrix: [[Boss]]
    var itemMatrix: [[Item]]
    var seedOptions: [SeedOption]

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

    var lockSettings: Bool = false
    var longPressDelay: Double
    
    var localMode: Bool {
        didSet {
            UserDefaults.standard.set(localMode, forKey: "localMode")
        }
    }
  
    var collectibleWallJump: Bool {
        didSet {
            UserDefaults.standard.set(collectibleWallJump, forKey: "collectibleWallJump")
            items[safe: .canwalljump].collected = collectibleWallJump ? 0 : 1
        }
    }
    
    var showEye: Bool {
        didSet {
            UserDefaults.standard.set(showEye, forKey: "showEye")
        }
    }

    var showOptionalPhantoonIcon: Bool {
        didSet {
            UserDefaults.standard.set(showOptionalPhantoonIcon, forKey: "showOptionalPhantoonIcon")
        }
    }

    var showCanWallJumpIcon: Bool {
        didSet {
            UserDefaults.standard.set(showCanWallJumpIcon, forKey: "showCanWallJumpIcon")
        }
    }

    var showWallJumpBoots: Bool {
        didSet {
            UserDefaults.standard.set(showWallJumpBoots, forKey: "showWallJumpBoots")
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
        self.seedOptionVStackSpacing = 20
        self.seedOptionsSpacing = 10
            
        #elseif os(macOS)
        self.isWindowActive = true
        self.bossSize = 65
        self.itemSize = 60
        self.seedOptionsWidth = 320
        self.seedOptionTitleFontSize = 18
        self.seedOptionSelectionFontSize = 28
        self.bossVerticalSpacing = 30
        self.rootVStackSpacing = 25
        self.rootHStackSpacing = 25
        self.itemGridHorizontalSpacing = 7
        self.itemGridVerticalSpacing = 3
        self.seedOptionVStackSpacing = 20
        self.seedOptionsSpacing = 10        
        #endif

        self.defaultActiveStates = [
            .walljump: UserDefaults.standard.boolWithDefaultValue(forKey: "collectibleWallJump", defaultValue: false),
            .eye: true,
            .phantoon: true,
            .canwalljump: false
        ]
        
        self.lockedSettingOpacity = 0.3
        self.longPressDelay = 0.2

        self.localMode = UserDefaults.standard.boolWithDefaultValue(forKey: "localMode", defaultValue: false)
        self.collectibleWallJump = UserDefaults.standard.boolWithDefaultValue(forKey: "collectibleWallJump", defaultValue: false)
        
        // Variables to turn icons on/off (purely cosmetic not game settings)
        self.showEye = UserDefaults.standard.boolWithDefaultValue(forKey: "showEye", defaultValue: false)
        self.showOptionalPhantoonIcon = UserDefaults.standard.boolWithDefaultValue(forKey: "showOptionalPhantoonIcon", defaultValue: false)
        self.showCanWallJumpIcon = UserDefaults.standard.boolWithDefaultValue(forKey: "showCanWallJumpIcon", defaultValue: false)
        self.showWallJumpBoots = UserDefaults.standard.boolWithDefaultValue(forKey: "showWallJumpBoots", defaultValue: UserDefaults.standard.boolWithDefaultValue(forKey: "collectibleWallJump", defaultValue: false))

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
            .spazer: Item(key: .spazer, name: "Spazer"),
            .plasma: Item(key: .plasma, name: "Plasma Beam"),
            .varia: Item(key: .varia, name: "Varia Suit"),
            .gravity: Item(key: .gravity, name: "Gravity Suit"),
            .grapple: Item(key: .grapple, name: "Grapple Beam"),
            .xray: Item(key: .xray, name: "XRay Scope"),
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
        
        if (items[safe: .walljump].isActive && items[safe: .canwalljump].isActive) {
            self.collectibleWallJumpMode = 3
        } else if (items[safe: .canwalljump].isActive) {
            self.collectibleWallJumpMode = 2
        } else if (items[safe: .walljump].isActive) {
            self.collectibleWallJumpMode = 1
        } else {
            self.collectibleWallJumpMode = 0
        }
        
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
    
    func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}
