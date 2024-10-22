//
//  Simple_TrackerApp.swift
//  Simple Tracker
//
//  Created by fiftyshadesofurban on 10/6/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

let appName:String = (Bundle.main.infoDictionary!["CFBundleName"] as? String)!
let appVersion:String = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
let buildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as? String

@main
struct SimpleTrackerApp: App {
    @State var viewModel = ViewModel()
    @State var peerConnection = PeerConnection()
    
    #if os(macOS)
    let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
    #endif
    
    func resetTracker() {
        viewModel.resetBosses()
        viewModel.resetItems()
    }
    
    #if os(macOS)
    init() {
        if let fontURL = Bundle.main.url(forResource: "super-metroid-snes", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
    
    func setupWindow() {
        // Ensure we are using AppKit to access the NSWindow
        if let window = NSApplication.shared.windows.first {
            window.titleVisibility = .hidden  // Hide the window title
            window.titlebarAppearsTransparent = true  // Make the title bar transparent
        }
    }
    
    func setupWindowStateListener() {
        NotificationCenter.default.addObserver(forName: NSWindow.didBecomeKeyNotification, object: nil, queue: .main) { _ in
            viewModel.isWindowActive = true
        }
        NotificationCenter.default.addObserver(forName: NSWindow.didResignKeyNotification, object: nil, queue: .main) { _ in
            viewModel.isWindowActive = false
        }
    }
    #endif

    struct aboutMenu: View {
        @Environment(\.openWindow) private var openWindow
        var body: some View {
            Button("About \(appName)") {
                openWindow(id: "about")
            }
        }
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
                            .tag(index)
                    }
                }
            }
            Picker("Collectible Wall Jump", selection: Binding(
                get: {viewModel.collectibleWallJump},
                set: {viewModel.collectibleWallJump = $0 })) {
                Text("Vanilla")
                    .tag(false)
                Text("Collectible")
                    .tag(true)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .environment(peerConnection)
                .onAppear {
                    #if os(macOS)
                    setupWindow()
                    setupWindowStateListener()
                    #endif
                    
                    peerConnection.setupAdvertiser()
                    peerConnection.setupBrowser()
                    peerConnection.viewModel = viewModel
                }
        }
        #if os(macOS)
        .defaultSize(width: 857, height: 468)
        .commands {
            CommandGroup(replacing: .appInfo) {
                aboutMenu()
            }
            CommandGroup(replacing: .newItem) {
                Button("Reset Tracker") {
                    resetTracker()
                }
                .keyboardShortcut("R", modifiers: [.command])
            }
            CommandGroup(replacing: .sidebar) {
                Button("\(viewModel.showEye ? "Hide" : "Show") Planet Awake Status") {
                    viewModel.showEye.toggle()
                }
                Button("\(viewModel.collectibleWallJump ? "Hide" : "Show") Wall Jump Boots") {
                    viewModel.collectibleWallJump.toggle()
                }
                Divider()
            }
            CommandMenu("Map Rando Settings") {
                settingsMenu()
                    .environment(viewModel)
            }
        }
        #endif
        #if os(macOS)
        // When I put this in the above macOS block the compiler can't parse it below the
        // WindowGroup modifiers so I put it here in its own solitary macOS block.
        Window("About \(appName)", id: "about") {
            About()
        }
        .defaultSize(width: min(419, screenSize.width * 0.60), height: min(541, screenSize.height * 0.60))
        #endif

    }
}
