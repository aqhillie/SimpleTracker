//
//  GameOptions.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/24/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct GameOptions: View {
    @Environment(ViewModel.self) private var viewModel
    #if os(iOS)
    let g: GeometryProxy
    #endif
    
    var body: some View {
        #if os(macOS)
        SeedOptions()
        .background(Color.black)
        #else
        if g.size.width > g.size.height {
            VStack {
                Spacer()
                #if os(iOS)
                MobileOptions(orientation: .landscape)
                    .minimumScaleFactor(0.1)
                Spacer()
                #endif
                SeedOptions()
                    .minimumScaleFactor(0.1)
                Spacer()
            }
            .background(Color.black)
        } else {
            HStack {
                SeedOptions()
                    .minimumScaleFactor(0.1)
                #if os(iOS)
                Spacer()
                MobileOptions()
                    .minimumScaleFactor(0.1)
                Spacer()
                #endif
            }
            .background(Color.black)
        }
        #endif
    }
}

struct SeedOptions: View {
    @Environment(ViewModel.self) private var viewModel
    #if os(macOS)
    @State private var yOffset: CGFloat = 0
    @State private var isScrollingDown = true
    @State private var scrollTimer: Timer?
    @State private var pauseTimer: Timer?
    
    private func pauseScrolling() {
        if scrollTimer != nil { stopAutoScrolling() }
        pauseTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            startAutoScrolling()
        }
    }
    
    private func startAutoScrolling() {
//        let scrollHeight = geometry.size.height
        let scrollHeight = 150.0
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { _ in
            withAnimation(.linear(duration: 0.04)) {
                if isScrollingDown {
                    yOffset -= 1
                    if yOffset < -scrollHeight {
                        isScrollingDown = false
                        pauseScrolling()
                    }
                } else {
                    yOffset += 1
                    if yOffset > 0 {
                        isScrollingDown = true
                        pauseScrolling()
                    }
                }
            }
        }
    }

    private func stopAutoScrolling() {
        if var scrollTimer = scrollTimer {
            scrollTimer.invalidate()
        }
        if var pauseTimer = pauseTimer {
            pauseTimer.invalidate()
        }
    }
    #endif
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
//        GeometryReader { geometry in
            ScrollView(showsIndicators: viewModel.broadcastMode ? false : true) {
                VStack(spacing: viewModel.seedOptionVStackSpacing) {
                    OptionSelector(key: "objective", title: "Objectives", options: viewModel.seedOptionData[safe: .objectives].options, selection: $viewModel.objective)
                        #if os(macOS)
                        .padding(.top, 10)
                        #endif
                    OptionSelector(key: "difficulty", title: "Difficulty", options: viewModel.seedOptionData[safe: .difficulty].options, colors: viewModel.seedOptionData[safe: .difficulty].colors, selection: $viewModel.difficulty)
                    OptionSelector(key: "itemProgression", title: "Item Progression", options: viewModel.seedOptionData[safe: .itemProgression].options, colors: viewModel.seedOptionData[safe: .itemProgression].colors,  selection: $viewModel.itemProgression)
                    OptionSelector(key: "qualityOfLife", title: "Quality of Life", options: viewModel.seedOptionData[safe: .qualityOfLife].options, colors: viewModel.seedOptionData[safe: .qualityOfLife].colors, selection: $viewModel.qualityOfLife)
                    OptionSelector(key: "mapLayout", title: "Map Layout", options: viewModel.seedOptionData[safe: .mapLayout].options, colors: viewModel.seedOptionData[safe: .mapLayout].colors,  selection: $viewModel.mapLayout)
                    OptionSelector(key: "doors", title: "Doors", options: viewModel.seedOptionData[safe: .doors].options, colors: viewModel.seedOptionData[safe: .doors].colors,  selection: $viewModel.doors)
                    OptionSelector(key: "startLocation", title: "Start Location", options: viewModel.seedOptionData[safe: .startLocation].options, colors: viewModel.seedOptionData[safe: .startLocation].colors,  selection: $viewModel.startLocation)
                    OptionSelectorBool(key: "collectibleWallJump", title: "Wall Jump", options: viewModel.seedOptionData[safe: .collectibleWallJump].options, colors: viewModel.seedOptionData[safe: .collectibleWallJump].colors, selection: $viewModel.collectibleWallJump)
                        #if os(macOS)
                        .padding(.bottom, 10)
                        #endif
                    #if os(iOS)
                    OptionSelectorItemToggle(key: .phantoon, title: "Optional Phantoon Icon", color: 0x808080)
                    #endif
                }
                #if os(macOS)
                .offset(y: yOffset)
                .onAppear {
//                    startAutoScrolling(geometry: geometry)
                    if (viewModel.broadcastMode) {
                        pauseScrolling()
                    }
                }
                .onDisappear {
                    if (viewModel.broadcastMode) {
                        stopAutoScrolling()
                    }
                }
                .onChange(of: viewModel.broadcastMode) {
                    if viewModel.broadcastMode {
                        startAutoScrolling()
                    } else {
                        stopAutoScrolling()
                        yOffset = 0
                    }
                }
                #endif
            }
            #if os(macOS)
            .disabled(viewModel.broadcastMode)
            #endif
            #if os(iOS)
            .frame(alignment: .center)
            #endif
//        }
    }
}
