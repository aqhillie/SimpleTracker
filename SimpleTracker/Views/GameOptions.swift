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
            ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                if (seedOption.visible) {
                    OptionSelector(seedOption: seedOption)
                }
            }
        }
        #else
        ScrollView {
            VStack(spacing: 10) {
                ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                    if (seedOption.visible) {
                        OptionSelector(seedOption: seedOption)
                    }
                }
                OptionSelectorMini(key: "collectibleWallJump", title: "Collectible Wall Jump", colors: [0x066815, 0x5B0012], options: ["Vanilla", "Collectible"], selection: viewModel.collectibleWallJump ? 1 : 0, setting: $viewModel.collectibleWallJump)
                OptionSelectorMini(key: "showOptionalPhantoonIcon", title: "Optional Phantoon Icon", colors: [0x808080], options: ["Disabled", "Enabled"], selection: viewModel.showOptionalPhantoonIcon ? 1 : 0, setting: $viewModel.showOptionalPhantoonIcon)
                OptionSelectorMini(key: "showCanWallJumpIcon", title: "Can Wall Jump Icon", colors: [0x808080], options: ["Disabled", "Enabled"], selection: viewModel.showCanWallJumpIcon ? 1 : 0, setting: $viewModel.showCanWallJumpIcon)
            }
        }
        .frame(alignment: .center)
        #endif
    }
}
