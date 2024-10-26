//
//  BossKey.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/25/24.
//
//  Copyright (C) 2024 Warpixel
//

enum BossKey: String {
    case empty
    case draygon
    case ridley
    case kraid
    case phantoon
    case metroids1
    case metroids2
    case metroids3
    case metroids4
    case chozo1
    case chozo2
    case pirates1
    case pirates2
    case pirates3
    case pirates4
    case bombtorizo
    case botwoon
    case crocomire
    case goldentorizo
    case sporespawn
    
//    static let dict: [String: BossKey] = [
//        "empty": .empty,
//        "draygon": .draygon,
//        "ridley": .ridley,
//        "kraid": .kraid,
//        "phantoon": .phantoon,
//        "metroids1": .metroids1,
//        "metroids2": .metroids2,
//        "metroids3": .metroids3,
//        "metroids4": .metroids4,
//        "chozo1": .chozo1,
//        "chozo2": .chozo2,
//        "pirates1": .pirates1,
//        "pirates2": .pirates2,
//        "pirates3": .pirates3,
//        "pirates4": .pirates4,
//        "bombtorizo": .bombtorizo,
//        "botwoon": .botwoon,
//        "crocomire": .crocomire,
//        "goldentorizo": .goldentorizo,
//        "sporespawn": .sporespawn
//    ]

    func toString() -> String {
        return self.rawValue // Returns the raw string value of the enum case
    }
}
