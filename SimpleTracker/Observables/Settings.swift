//
//  Settings.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/13/24.
//

import SwiftUI

@Observable
class AppSettings {
    // Defaults
    static let defaultObjective: Int = 1
    static let defaultDifficulty: Int = 0
    static let defaultItemProgression: Int = 0
    static let defaultQualityOfLife: Int = 2
    static let defaultMapLayout: Int = 1
    static let defaultCollectibleWallJump: Bool = false
    static let defaultShowSeedName: Bool = false
    static let defaultShowPlanetWakeStatus: Bool = false
    
    static let defaults: UserDefaults = UserDefaults.standard
    
    // seed settings
    var objective: Int = (defaults.object(forKey: "objectives") != nil) ? defaults.integer(forKey: "objectives") : AppSettings.defaultObjective
    var difficulty: Int = (defaults.object(forKey: "difficulty") != nil) ? defaults.integer(forKey: "difficulty") : AppSettings.defaultDifficulty
    var itemProgression: Int = (defaults.object(forKey: "item progression") != nil) ? defaults.integer(forKey: "item progression") : AppSettings.defaultItemProgression
    var qualityOfLife: Int = (defaults.object(forKey: "quality of life") != nil) ? defaults.integer(forKey: "quality of life") : AppSettings.defaultQualityOfLife
    var mapLayout: Int = (defaults.object(forKey: "map layout") != nil) ? defaults.integer(forKey: "map layout") : AppSettings.defaultMapLayout
    
    // other settings
    var seedName: String = defaults.string(forKey: "seedName") ?? ""
    var showSeedName: Bool = (defaults.object(forKey: "showSeedName") != nil) ? defaults.bool(forKey: "showSeedName") : AppSettings.defaultShowSeedName
    var showPlanetWakeStatus: Bool = (defaults.object(forKey: "showPlanetWakeStatus") != nil) ? defaults.bool(forKey: "showPlanetWakeStatus") : AppSettings.defaultShowPlanetWakeStatus
    var collectibleWallJump: Bool = (defaults.object(forKey: "collectibleWallJump") != nil) ? defaults.bool(forKey: "collectibleWallJump") : AppSettings.defaultCollectibleWallJump
}
