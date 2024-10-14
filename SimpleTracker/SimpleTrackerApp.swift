//
//  Simple_TrackerApp.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

@main
struct SimpleTrackerApp: App {
    @State var appState = AppState()
    @State var appSettings = AppSettings()
    
    func setCollectibleWallJump(to: Bool) {
        print(appSettings.collectibleWallJump)
        appSettings.collectibleWallJump = to
        print(appSettings.collectibleWallJump)
    }
    
    func resetTracker() {
        // bosses
        appState.ridleyDead = false
        appState.phantoonDead = false
        appState.kraidDead = false
        appState.draygonDead = false
        
        // items
        appState.chargeBeamCollected = false
        appState.iceBeamCollected = false
        appState.waveBeamCollected = false
        appState.spazerCollected = false
        appState.plasmaBeamCollected = false
        appState.variaSuitCollected = false
        appState.gravitySuitCollected = false
        appState.grappleBeamCollected = false
        appState.xrayScopeCollected = false
        appState.morphBallCollected = false
        appState.bombCollected = false
        appState.springballCollected = false
        appState.screwAttackCollected = false
        appState.hijumpCollected = false
        appState.spaceJumpCollected = false
        appState.speedBoosterCollected = false
        appState.walljumpCollected = false
        appState.missilesCollected = 0
        appState.supersCollected = 0
        appState.powerbombsCollected = 0
        appState.etanksCollected = 0
        appState.reservetanksCollected = 0
        
        // other
        appState.isPlanetAwake = false
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(appSettings)
        }
        .defaultSize(width: 857, height: 468)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Reset Tracker") {
                    resetTracker()
                }
                .keyboardShortcut("R", modifiers: [.command])
            }
            CommandMenu("Settings") {
                Button(appSettings.showSeedName ? "Hide Seed Name" : "Show Seed Name") {
                    appSettings.showSeedName.toggle()
                    AppSettings.defaults.set(appSettings.showSeedName, forKey: "showSeedName")
                }
                Divider()
                Menu("Wall Jump") {
                    Button("Vanilla") {
                        setCollectibleWallJump(to: false)
                        AppSettings.defaults.set(false, forKey: "collectibleWallJump")
                    }
                    Button("Collectible") {
                        setCollectibleWallJump(to: true)
                        AppSettings.defaults.set(true, forKey: "collectibleWallJump")
                    }
                }
            }
        }
    }
}
