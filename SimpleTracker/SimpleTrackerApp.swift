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

    struct settingsMenu: View {
        @Environment(ViewModel.self) private var viewModel
        
        var body: some View {
            ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                Picker(seedOption.title, selection: Binding(
                    get: { seedOption.selection },
                    set: { seedOption.update($0) })) {
                    ForEach(Array(seedOption.options.enumerated()), id: \.offset) { index, option in
                        Text(option)
                            .tag(index) // Use 'index' as the tag if you're selecting by index
                    }
                }
            }
        }
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
            //                CommandMenu("View") {
            //                    Button(appSettings.showSeedName ? "Hide Seed Name" : "Show Seed Name") {
            //                        appSettings.showSeedName.toggle()
            //                        AppSettings.defaults.set(appSettings.showSeedName, forKey: "showSeedName")
            //                    }
            //                }
            CommandMenu("Settings") {
                settingsMenu()
                    .environment(viewModel)
            }
        }
    }
}
