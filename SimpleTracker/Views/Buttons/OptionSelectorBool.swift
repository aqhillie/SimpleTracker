//
//  OptionSelectorMini.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/22/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct OptionSelectorBool: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    let key: String
    let title: String
    let options: [String]
    let colors: [UInt]
    @Binding var selection: Bool
        
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
            Text(options[selection ? 1 : 0].uppercased())
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: selection ? 1 : 0, colors: colors)))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
        }
            .gesture(
                TapGesture()
                    .onEnded {
                        if (!viewModel.broadcastMode) {
                            selection.toggle()
                            let message = [
                                "type": "cmd",
                                "key": key,
                                "value": selection
                            ]
                            peerConnection.sendMessage(message)
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
            Text(options[selection ? 1 : 0].uppercased())
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: selection ? 1 : 0, colors: colors)))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
            Spacer()
                .frame(minHeight: 0, maxHeight: 20)
        }
        .opacity(viewModel.broadcastMode ? viewModel.lockedSettingOpacity : 1)
            .gesture(
                TapGesture()
                    .onEnded {
                        if (!viewModel.broadcastMode) {
                            selection.toggle()
                            let message = [
                                "type": "cmd",
                                "key": key,
                                "value": selection
                            ]
                            peerConnection.sendMessage(message)
                        }
                    }
            )
        #endif
    }
}
