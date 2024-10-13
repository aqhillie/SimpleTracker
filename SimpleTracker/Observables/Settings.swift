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
    static let defaultQol: Int = 2
    static let defaultMapLayout: Int = 1
    static let defaultCollectibleWallJump: Bool = false

    var objective: Int = AppSettings.defaultObjective
    var difficulty: Int = AppSettings.defaultDifficulty
    var qol: Int = AppSettings.defaultQol
    var mapLayout: Int = AppSettings.defaultMapLayout
    var collectibleWallJump: Bool = AppSettings.defaultCollectibleWallJump
}
