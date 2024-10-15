//
//  config.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

@Observable
class ViewModel {
    
    var bosses  :   [Boss]
    var items   :   [Item]
    var options :   [Option]
    
    init() {
        
        self.bosses  = [
            Boss(name: "ridley"),
            Boss(name: "phantoon"),
            Boss(name: "kraid"),
            Boss(name: "draygon")
        ]
        self.items   = [
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
            Item(name: "walljump", isActive: false),
            Item(name: ""),
            Item(name: ""),
            Item(name: "missile", maxValue: 46, multiplier: 5),
            Item(name: "super", maxValue: 10, multiplier: 5),
            Item(name: "powerbomb", maxValue: 10, multiplier: 5),
            Item(name: "etank", maxValue: 14),
            Item(name: "reservetank", maxValue: 4),
            Item(name: "")
            
        ]
        self.options = [
            Option(key: "objective",
                       title: "Objectives",
                       options: ["None",
                                 "Bosses",
                                 "Minibosses",
                                 "Metroids",
                                 "Chozos",
                                 "Pirates",
                                 "Random"],
                       colors: [.color01],
                       selection: 1),
            Option(key: "difficulty",
                       title: "Difficulty",
                       options: ["Basic",
                                 "Medium",
                                 "Hard",
                                 "Very Hard",
                                 "Expert",
                                 "Extreme",
                                 "Insane"],
                       colors: [.color02,
                                .color03,
                                .color04,
                                .color05,
                                .color06,
                                .color07,
                                .color08],
                       selection: 0),
            Option(key: "itemProgression",
                       title: "Item Progression",
                       options: ["Normal",
                                 "Tricky",
                                 "Challenge",
                                 "Desolate"],
                       colors: [.color02,
                                .color03,
                                .color04,
                                .color08],
                       selection: 0),
            Option(key: "qol",
                       title: "Quality of Life",
                       options: ["Off",
                                 "Low",
                                 "Default",
                                 "Max"],
                       colors: [.color05,
                                .color04,
                                .color03,
                                .color02],
                       selection: 2),
            Option(key: "mapLayout",
                       title: "Map Layout",
                       options: ["Vanilla",
                                 "Tame",
                                 "Wild"],
                       colors: [.color02,
                                .color03,
                                .color04],
                       selection: 1)
        ]

    }
    
    func resetBosses() {
        for boss in bosses {
            boss.reset()
        }
    }
    
    func resetItems() {
        for item in items {
            item.reset()
        }
    }
    
    func resetOptions() {
        for option in options {
            option.reset()
        }
    }
    
    func resetUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }

    func userDefaultsSize() -> Int? {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return data.count
        } catch {
            print("Error serializing UserDefaults: \(error)")
        }
        return nil
    }
        
}
