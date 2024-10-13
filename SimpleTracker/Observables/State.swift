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
    var chargeCollected: Bool = false
    var iceCollected: Bool = false
    var waveCollected: Bool = false
    var spazerCollected: Bool = false
    var plasmaCollected: Bool = false
    
    var variaCollected: Bool = false
    var gravityCollected: Bool = false
    var grappleCollected: Bool = false
    var xrayCollected: Bool = false
    var morphCollected: Bool = false
    var bombCollected: Bool = false
    var springballCollected: Bool = false
    var screwCollected: Bool = false
    var hijumpCollected: Bool = false
    var spaceCollected: Bool = false
    var speedCollected: Bool = false
    
    // Only relevant if AppSettings.collectibleWallJump is turned on
    var walljumpCollected:Bool = false
    
    var missilesCollected: Int = 0
    var supersCollected: Int = 0
    var powerbombsCollected: Int = 0
    var etanksCollected: Int = 0
    var reservetanksCollected: Int = 0
}
