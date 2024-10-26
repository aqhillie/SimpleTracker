//
//  ToggleOptionalPhantoon.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/26/24.
//

import SwiftUI

struct ToggleOptionalPhantoon: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
            viewModel.items[safe: .phantoon].isActive.toggle()
            let message = [
                "type": "item",
                "key": "phantoon",
                "value": [
                    "isActive": viewModel.items[safe: .phantoon].isActive
                ]
            ]
            peerConnection.sendMessage(message)
        }) {
            ZStack {
                Image("phantoon")
                    .resizable()
                    .frame(width: size, height: size)
                    .saturation(0)
                    .brightness(0.2)
                Slash(size: size)
                    .opacity(viewModel.items[safe: .phantoon].isActive ? 0 : 1)
            }
            .opacity(viewModel.broadcastMode ? viewModel.lockedSettingOpacity : 1)
        }
        .help("Toggle Optional Phantoon Icon")
        .disabled(viewModel.broadcastMode)
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
