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
    case random1
    case random2
    case random3
    case random4

    func toString() -> String {
        return self.rawValue // Returns the raw string value of the enum case
    }
}
