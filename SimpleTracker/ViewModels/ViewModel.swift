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

    let wallJumpBootsItem: Item
    let canWallJumpItem: Item
    let planetAwakeItem: Item
    let optionalPhantoon: Item
    
    #if os(macOS)
    var isWindowActive: Bool
    let rootVStackSpacing: CGFloat
    let rootHStackSpacing: CGFloat
    let bossVerticalSpacing: CGFloat
    let itemGridHorizontalSpacing: CGFloat
    let itemGridVerticalSpacing: CGFloat
    let fifthItemRow: [Item]
    let sixthItemRowBosses: [Item]
    let sixthItemRowOthers: [Item]
    #endif

    var bosses: [[Boss]]
    var items: [[Item]]
    var seedOptions: [SeedOption]

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
            canWallJumpItem.collected = collectibleWallJump ? 0 : 1
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

        self.lockedSettingOpacity = 0.3
        self.longPressDelay = 0.2

        self.localMode = UserDefaults.standard.boolWithDefaultValue(forKey: "localMode", defaultValue: false)
        self.collectibleWallJump = UserDefaults.standard.boolWithDefaultValue(forKey: "collectibleWallJump", defaultValue: false)
        
        // Variables to turn icons on/off (purely cosmetic not game settings)
        self.showEye = UserDefaults.standard.boolWithDefaultValue(forKey: "showEye", defaultValue: false)
        self.showOptionalPhantoonIcon = UserDefaults.standard.boolWithDefaultValue(forKey: "showOptionalPhantoonIcon", defaultValue: false)
        self.showCanWallJumpIcon = UserDefaults.standard.boolWithDefaultValue(forKey: "showCanWallJumpIcon", defaultValue: false)
        self.showWallJumpBoots = UserDefaults.standard.boolWithDefaultValue(forKey: "showWallJumpBoots", defaultValue: UserDefaults.standard.boolWithDefaultValue(forKey: "collectibleWallJump", defaultValue: false))

        self.bosses = [
            [],
            [
                Boss(key: "ridley", name: "Ridley", deadImage: "ridleydead"),
                Boss(key: "phantoon", name: "Phantoon", deadImage: "phantoondead"),
                Boss(key: "kraid", name: "Kraid", deadImage: "kraiddead"),
                Boss(key: "draygon", name: "Draygon", deadImage: "draygondead")
            ],
            [
                Boss(key: "bombtorizo", name: "Bomb Torizo", deadImage: "bombtorizodead"),
                Boss(key: "sporespawn", name: "Spore Spawn", deadImage: "sporespawndead"),
                Boss(key: "crocomire", name: "Crocomire", deadImage: "crocomiredead"),
                Boss(key: "botwoon", name: "Botwoon", deadImage: "botwoondead"),
                Boss(key: "goldentorizo", name: "Golden Torizo", deadImage: "goldentorizodead")
            ],
            [
                Boss(key: "metroids1", name: "Metroids 1", deadImage: "metroids1dead"),
                Boss(key: "metroids2", name: "Metroids 2", deadImage: "metroids2dead"),
                Boss(key: "metroids3", name: "Metroids 3", deadImage: "metroids3dead"),
                Boss(key: "metroids4", name: "Metroids 4", deadImage: "metroids4dead")
            ],
            [
                Boss(key: "chozo1", name: "Chozo Statue 1", deadImage: "chozo1dead"),
                Boss(key: "chozo2", name: "Chozo Statue 2", deadImage: "chozo2dead"),
                EmptyBoss(),
                EmptyBoss()
            ],
            [
                Boss(key: "pirates1", name: "Pirates 1"),
                Boss(key: "pirates2", name: "Pirates 2"),
                Boss(key: "pirates3", name: "Pirates 3"),
                Boss(key: "pirates4", name: "Pirates 4")
            ],
            []
        ]

        self.wallJumpBootsItem = Item(key: "walljump", name: "Wall Jump Boots")
        self.canWallJumpItem = CanWallJumpItem()
        self.planetAwakeItem = EyeItem()
        self.optionalPhantoon = PhantoonItem()

        wallJumpBootsItem.linkedItem = canWallJumpItem
        canWallJumpItem.linkedItem = wallJumpBootsItem

        #if os(macOS)
        self.sixthItemRowBosses = [
            EmptyItem(),
            EmptyItem(),
            planetAwakeItem,
            canWallJumpItem,
            EmptyItem()
        ]
        self.sixthItemRowOthers = [
            EmptyItem(),
            planetAwakeItem,
            optionalPhantoon,
            canWallJumpItem,
            EmptyItem()
        ]
        #endif
        
        #if os(macOS)
        self.fifthItemRow = [
            Item(key: "plasma", name: "Plasma Beam"),
            Item(key: "xray", name: "XRay Scope"),
            EmptyItem(),
            EmptyItem(),
            Item(key: "reservetank", name: "Reserve Tanks", maxValue: 4)
        ]

        self.items = [
            [
                Item(key: "charge", name: "Charge Beam"),
                Item(key: "ice", name: "Ice Beam"),
                Item(key: "wave", name: "Wave Beam"),
                Item(key: "spazer", name: "Spazer"),
                Item(key: "plasma", name: "Plasma Beam")
            ],
            [
                Item(key: "varia", name: "Varia Suit"),
                Item(key: "gravity", name: "Gravity Suit"),
                EmptyItem(),
                Item(key: "grapple", name: "Grapple Beam"),
                Item(key: "xray", name: "XRay Scope")
            ],
            [
                Item(key: "morph", name: "Morphing Ball"),
                Item(key: "bomb", name: "Morph Ball Bombs"),
                Item(key: "springball", name: "Spring Ball"),
                Item(key: "screw", name: "Screw Attack"),
                EmptyItem()
            ],
            [
                Item(key: "hijump", name: "HiJump Boots"),
                Item(key: "space", name: "Space Jump"),
                Item(key: "speed", name: "Speed Booster"),
                wallJumpBootsItem,
                EmptyItem()
            ],
            [
                Item(key: "missile", name: "Missiles", maxValue: 46, multiplier: 5),
                Item(key: "super", name: "Super Missiles", maxValue: 10, multiplier: 5),
                Item(key: "powerbomb", name: "Power Bombs", maxValue: 10, multiplier: 5),
                Item(key: "etank", name: "Energy Tanks", maxValue: 14),
                Item(key: "reservetank", name: "Reserve Tanks", maxValue: 4)
            ]
        ]
        #elseif os(iOS)
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
                canWallJumpItem,
                Item(key: "springball", name: "Spring Ball"),
                Item(key: "speed", name: "Speed Booster"),
                Item(key: "powerbomb", name: "Power Bombs", maxValue: 10, multiplier: 5)
            ],
            [
                Item(key: "spazer", name: "Spazer"),
                Item(key: "grapple", name: "Grapple Beam"),
                Item(key: "screw", name: "Screw Attack"),
                wallJumpBootsItem,
                Item(key: "etank", name: "Energy Tanks", maxValue: 14)
            ],
            [
                Item(key: "plasma", name: "Plasma Beam"),
                Item(key: "xray", name: "XRay Scope"),
                planetAwakeItem,
                PhantoonItem(),
                Item(key: "reservetank", name: "Reserve Tanks", maxValue: 4)
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
        for objectiveBosses in bosses {
            for boss in objectiveBosses {
                boss.reset()
            }
        }
    }
    
    func resetItems() {
        for itemRow in items {
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
        
        for objectiveBosses in bosses {
            for boss in objectiveBosses {
                if boss.key == key {
                    boss._isDead = value
                    return
                }
            }
        }
    }
    
    func updateItem(from message: [String: Any]) {
        guard let key = message["key"] as? String,
              let value = message["value"] as? Int else { return }

        #if os(macOS)
        for item in sixthItemRowOthers {
            if item.key == key && item.collected != value{
                item.collected = value
                return
            }
        }
        #endif
        for itemRow in items {
            for item in itemRow {
                if item.key == key && item.collected != value {
                    item.collected = value
                    return
                }
            }
        }
    }
    
    func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}
