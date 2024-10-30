//
//  Simple_TrackerApp.swift
//  Simple Tracker
//
//  Created by fiftyshadesofurban on 10/6/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

@main
struct SimpleTrackerApp: App {
    @State var viewModel: ViewModel
    @State var timerViewModel: TimerViewModel
    @State var peerConnection: PeerConnection

    init() {
        let viewModel = ViewModel()
        let timerViewModel = TimerViewModel()
        let peerConnection = PeerConnection(viewModel: viewModel, timerViewModel: timerViewModel)
        
        self.viewModel = viewModel
        self.timerViewModel = timerViewModel
        
        self.peerConnection = peerConnection
        
        if (SeedData.checkSeed()) {
            SeedData.loadSeed(into: viewModel)
        }
        
        #if os(macOS)
        if let fontURL = Bundle.main.url(forResource: "super-metroid-snes", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
        if let fontURL = Bundle.main.url(forResource: "big_noodle_titling", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
        #endif
    }
    
    #if os(macOS)
    let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
    #endif
    
    func resetTracker() {
        viewModel.resetBosses()
        viewModel.resetItems()
        viewModel.items[safe: .walljump].collected = viewModel.collectibleWallJump ? 0 : 1
        let message = [
            "type": "cmd",
            "key": "resetTracker",
            "value": ""
        ]
        peerConnection.sendMessage(message)

        let seedData = SeedData.create(from: viewModel)
        seedData.save()
    }
    
    #if os(macOS)
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
        let pc: PeerConnection

        var body: some View {
            @Bindable var viewModel = viewModel
            Picker(viewModel.seedOptionData[safe: .objectives].title, selection: $viewModel.objective) {
                ForEach(Array(viewModel.seedOptionData[safe: .objectives].options.enumerated()), id: \.offset) { index, option in
                    Text(option)
                        .tag(index)
                }
            }
            Picker(viewModel.seedOptionData[safe: .difficulty].title, selection: $viewModel.difficulty) {
                ForEach(Array(viewModel.seedOptionData[safe: .difficulty].options.enumerated()), id: \.offset) { index, option in
                    Text(option)
                        .tag(index)
                }
            }
            Picker(viewModel.seedOptionData[safe: .itemProgression].title, selection: $viewModel.itemProgression) {
                ForEach(Array(viewModel.seedOptionData[safe: .itemProgression].options.enumerated()), id: \.offset) { index, option in
                    Text(option)
                        .tag(index)
                }
            }
            Picker(viewModel.seedOptionData[safe: .qualityOfLife].title, selection: $viewModel.qualityOfLife) {
                ForEach(Array(viewModel.seedOptionData[safe: .qualityOfLife].options.enumerated()), id: \.offset) { index, option in
                    Text(option)
                        .tag(index)
                }
            }
            Picker(viewModel.seedOptionData[safe: .mapLayout].title, selection: $viewModel.mapLayout) {
                ForEach(Array(viewModel.seedOptionData[safe: .mapLayout].options.enumerated()), id: \.offset) { index, option in
                    Text(option)
                        .tag(index)
                }
            }
            Picker(viewModel.seedOptionData[safe: .collectibleWallJump].title, selection: $viewModel.collectibleWallJump) {
                ForEach(Array(viewModel.seedOptionData[safe: .collectibleWallJump].options.enumerated()), id: \.offset) { index, option in
                    Text(option)
                        .tag(index % 2 == 0 ? false : true)
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .environment(peerConnection)
                .environment(timerViewModel)
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
                    let message = [
                        "type": "cmd",
                        "key": "resetTracker",
                        "value": ""
                    ]
                    peerConnection.sendMessage(message)
                }
                .keyboardShortcut("R", modifiers: [.command])
            }
            CommandGroup(replacing: .sidebar) {
                Button("\(timerViewModel.isVisible ? "Hide" : "Show") Timer") {
                    if (timerViewModel.isVisible) {
                        timerViewModel.resetTimer()
                    }
                    timerViewModel.isVisible.toggle()
                    UserDefaults.standard.set(timerViewModel.isVisible, forKey: "timerVisibility")
                    let message = [
                        "type": "cmd",
                        "key": "timerVisibility",
                        "value": timerViewModel.isVisible
                    ]
                    peerConnection.sendMessage(message)
                    resizeWindowToFitContent()
                }
                Divider()
                Button("\(viewModel.items[safe: .eye].isActive ? "Hide" : "Show") Planet Awake Status") {
                    viewModel.items[safe: .eye].isActive.toggle()
                    let message = [
                        "type": "item",
                        "key": "eye",
                        "value": [
                            "isActive": viewModel.items[safe: .eye].isActive
                        ]
                    ]
                    peerConnection.sendMessage(message)
                }
                Button("\(viewModel.items[safe: .phantoon].isActive ? "Hide" : "Show") Optional Phantoon Icon") {
                    viewModel.items[safe: .phantoon].isActive.toggle()
                    let message = [
                        "type": "item",
                        "key": "phantoon",
                        "value": [
                            "isActive": viewModel.items[safe: .phantoon].isActive
                        ]
                    ]
                    peerConnection.sendMessage(message)
                }
                Picker("Collectible Wall Jump Mode", selection: $viewModel.collectibleWallJumpMode) {
                    Text("None")
                        .tag(0)
                    Text("Wall Jump Boots")
                        .tag(1)
                    Text("Can Wall Jump Icon")
                        .tag(2)
                    Text("Both")
                        .tag(3)
                }
                Divider()
            }
            CommandMenu("Map Rando Settings") {
                settingsMenu(pc: peerConnection)
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
