//
//  Simple_TrackerApp.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI


@main
struct Simple_TrackerApp: App {
    
    @State var appState: ViewModel
    
    init() {
        self.appState = ViewModel()
    }

    
    func resetTracker() {
        appState.resetBosses()
        appState.resetItems()
        appState.resetOptions()
        appState.resetUserDefaults()
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
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
