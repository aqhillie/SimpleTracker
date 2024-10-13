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
    
    func resetTracker() {
        appState.ridleyDead = false
        appState.phantoonDead = false
        appState.kraidDead = false
        appState.draygonDead = false
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
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
