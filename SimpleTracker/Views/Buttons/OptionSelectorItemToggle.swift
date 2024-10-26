//
//  OptionSelectorItemToggle.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/25/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct OptionSelectorItemToggle: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    let key: ItemKey
    let title: String
    let color: UInt
    @State var selection: Bool
//    @State var loaded: Bool
    
    init(key: ItemKey, title: String, color: UInt) {
        self.key = key
        self.title = title
        self.color = color
        self.selection = false
//        self.loaded = false
    }
            
    var body: some View {
        #if os(macOS)
        VStack(spacing: viewModel.seedOptionsSpacing) {
            Text(title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: viewModel.seedOptionTitleFontSize))
            Text(selection ? "ENABLED" : "DISABLED")
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(color))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
        }
            .gesture(
                TapGesture()
                    .onEnded {
                        if (!viewModel.lockSettings) {
                            selection.toggle()
                            viewModel.items[safe: key].isActive = selection
                        }
                    }
            )
        #else
        VStack {
            Text(title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: viewModel.seedOptionTitleFontSize))
            Spacer()
                .frame(minHeight: 2, maxHeight: 5)
            Text(selection ? "ENABLED" : "DISABLED")
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(color))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
            Spacer()
                .frame(minHeight: 0, maxHeight: 20)
        }
        .onAppear {
//                if (!loaded) {
                selection = UserDefaults.standard.boolWithDefaultValue(forKey: "\(key.toString())_isActive", defaultValue: viewModel.defaultActiveStates[safe: key])
//                    loaded = true
//                }
        }
        .opacity(viewModel.lockSettings ? viewModel.lockedSettingOpacity : 1)
            .gesture(
                TapGesture()
                    .onEnded {
                        if (!viewModel.lockSettings) {
                            selection.toggle()
                            viewModel.items[safe: key].isActive = selection
                            let message = [
                                "type": "item",
                                "key": key.toString(),
                                "value": [
                                    "isActive": viewModel.items[safe: key].isActive
                                ]
                            ]
                            peerConnection.sendMessage(message)
                        }
                    }
            )
        #endif
    }
}
