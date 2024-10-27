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

    var body: some View {
        @Bindable var viewModel = viewModel
        
        #if os(macOS)
        VStack(spacing: viewModel.seedOptionVStackSpacing) {
            OptionSelector(key: "objective", title: "Objectives", options: viewModel.seedOptionData[safe: .objectives].options, selection: $viewModel.objective)
            OptionSelector(key: "difficulty", title: "Difficulty", options: viewModel.seedOptionData[safe: .difficulty].options, colors: viewModel.seedOptionData[safe: .difficulty].colors, selection: $viewModel.difficulty)
            OptionSelector(key: "itemProgression", title: "Item Progression", options: viewModel.seedOptionData[safe: .itemProgression].options, colors: viewModel.seedOptionData[safe: .itemProgression].colors,  selection: $viewModel.itemProgression)
            OptionSelector(key: "qualityOfLife", title: "Quality of Life", options: viewModel.seedOptionData[safe: .qualityOfLife].options, colors: viewModel.seedOptionData[safe: .qualityOfLife].colors, selection: $viewModel.qualityOfLife)
            OptionSelector(key: "mapLayout", title: "Map Layout", options: viewModel.seedOptionData[safe: .mapLayout].options, colors: viewModel.seedOptionData[safe: .mapLayout].colors,  selection: $viewModel.mapLayout)
            OptionSelectorBool(key: "collectibleWallJump", title: "Collectible Wall Jump", options: viewModel.seedOptionData[safe: .collectibleWallJump].options, colors: viewModel.seedOptionData[safe: .collectibleWallJump].colors, selection: $viewModel.collectibleWallJump)
        }
        #else
        ScrollView {
            VStack(spacing: 10) {
                OptionSelector(key: "objective", title: "Objectives", options: viewModel.seedOptionData[safe: .objectives].options, selection: $viewModel.objective)
                OptionSelector(key: "difficulty", title: "Difficulty", options: viewModel.seedOptionData[safe: .difficulty].options, colors: viewModel.seedOptionData[safe: .difficulty].colors, selection: $viewModel.difficulty)
                OptionSelector(key: "itemProgression", title: "Item Progression", options: viewModel.seedOptionData[safe: .itemProgression].options, colors: viewModel.seedOptionData[safe: .itemProgression].colors,  selection: $viewModel.itemProgression)
                OptionSelector(key: "qualityOfLife", title: "Quality of Life", options: viewModel.seedOptionData[safe: .qualityOfLife].options, colors: viewModel.seedOptionData[safe: .qualityOfLife].colors, selection: $viewModel.qualityOfLife)
                OptionSelector(key: "mapLayout", title: "Map Layout", options: viewModel.seedOptionData[safe: .mapLayout].options, colors: viewModel.seedOptionData[safe: .mapLayout].colors,  selection: $viewModel.mapLayout)
                OptionSelectorBool(key: "collectibleWallJump", title: "Collectible Wall Jump", options: viewModel.seedOptionData[safe: .collectibleWallJump].options, colors: viewModel.seedOptionData[safe: .collectibleWallJump].colors, selection: $viewModel.collectibleWallJump)
                OptionSelectorItemToggle(key: .phantoon, title: "Optional Phantoon Icon", color: 0x808080)
            }
        }
        .frame(alignment: .center)
        #endif
    }
}
