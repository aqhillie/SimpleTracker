//
//  Simple_TrackerApp.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

@main
struct SimpleTrackerApp: App {
    @State var viewModel = ViewModel()
        
    func resetTracker() {
        viewModel.resetBosses()
        viewModel.resetItems()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
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
//                CommandMenu("View") {
//                    Button(appSettings.showSeedName ? "Hide Seed Name" : "Show Seed Name") {
//                        appSettings.showSeedName.toggle()
//                        AppSettings.defaults.set(appSettings.showSeedName, forKey: "showSeedName")
//                    }
//                }
                ForEach(Array(viewModel.seedOptions.enumerated()), id: \.offset) { index, seedOption in
                    ForEach(Array(seedOption.enumerated()), id: \.offset) { index, seedOption in
                        Menu(seedOption.title) {
                            ForEach(Array(seedOption.options.enumerated()), id: \.offset) { index, option in
                                Button(option) {
                                    seedOption.update(selection: index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
