//
//  Simple_TrackerApp.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI


@main
struct Simple_TrackerApp: App {
    func resetTracker() {
        for bossName in bossNames {
            defaults.set(false, forKey: bossName)
        }
        for itemName in itemNames {
            if consumables.contains(itemName) {
                defaults.set(0, forKey: itemName)
            } else {
                defaults.set(false, forKey: itemName)
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
