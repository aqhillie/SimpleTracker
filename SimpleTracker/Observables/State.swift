//
//  State.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/13/24.
//

import SwiftUI

@Observable
class AppState {
    // Bosses
    var ridleyDead: Bool = false
    var phantoonDead: Bool = false
    var kraidDead: Bool = false
    var draygonDead: Bool = false
    
    // Items
    var chargeBeamCollected: Bool = false
    var iceBeamCollected: Bool = false
    var waveBeamCollected: Bool = false
    var spazerCollected: Bool = false
    var plasmaBeamCollected: Bool = false
    
    var variaSuitCollected: Bool = false
    var gravitySuitCollected: Bool = false
    var grappleBeamCollected: Bool = false
    var xrayScopeCollected: Bool = false
    var morphBallCollected: Bool = false
    var bombCollected: Bool = false
    var springballCollected: Bool = false
    var screwAttackCollected: Bool = false
    var hijumpCollected: Bool = false
    var spaceJumpCollected: Bool = false
    var speedBoosterCollected: Bool = false
    
    // Only relevant if AppSettings.collectibleWallJump is turned on
    var walljumpCollected:Bool = false
    
    var missilesCollected: Int = 0
    var supersCollected: Int = 0
    var powerbombsCollected: Int = 0
    var etanksCollected: Int = 0
    var reservetanksCollected: Int = 0
}
