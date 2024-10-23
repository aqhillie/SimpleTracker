//
//  OptionSelectorMini.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/22/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct OptionSelectorMini: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    let key: String
    let title: String
    let colors: [UInt]
    let options: [String]
    @State var selection: Int {
        didSet {
            setting = selection == 1 ? true : false
            let message = [
                "type": "cmd",
                "key": key,
                "value": setting
            ] as [String : Any]
            peerConnection.sendMessage(message)
        }
    }
    @Binding var setting: Bool
        
    private func getColor(idx: Int, colors: [UInt]) -> UInt {
        if idx > colors.count - 1 {
            return colors[colors.count - 1]
        } else {
            return colors[idx]
        }
    }
    
    var body: some View {
        #if os(macOS)
        VStack(spacing: viewModel.seedOptionsSpacing) {
            Text(title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: viewModel.seedOptionTitleFontSize))
            Text(options[selection].uppercased())
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: selection, colors: colors)))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
        }
            .gesture(
                TapGesture()
                    .onEnded {
                        if (!viewModel.lockSettings) {
                            selection = (selection + 1) % options.count
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
            Text(options[selection].uppercased())
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: selection, colors: colors)))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
            Spacer()
                .frame(minHeight: 0, maxHeight: 20)
        }
        .opacity(viewModel.lockSettings ? viewModel.lockedSettingOpacity : 1)
            .gesture(
                TapGesture()
                    .onEnded {
                        if (!viewModel.lockSettings) {
                            selection = (selection + 1) % options.count
                        }
                    }
            )
        #endif
    }
}
