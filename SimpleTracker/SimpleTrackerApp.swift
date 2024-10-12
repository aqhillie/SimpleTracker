//
//  Simple_TrackerApp.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI


@main
struct Simple_TrackerApp: App {
    
    @State var appState = AppState()
    
    func resetTracker() {
        for bossName in appState.bossNames {
            UserDefaults.standard.set(false, forKey: bossName)
        }
        for itemName in appState.itemNames {
            if appState.consumables.contains(itemName) {
                UserDefaults.standard.set(0, forKey: itemName)
            } else {
                UserDefaults.standard.set(false, forKey: itemName)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Reset Tracker") {
                    resetTracker()
                }
                .keyboardShortcut("R", modifiers: [.command])
            }
        }
    }
}
