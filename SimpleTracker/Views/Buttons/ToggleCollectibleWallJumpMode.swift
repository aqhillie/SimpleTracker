//
//  CollectibleWallJump.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/18/24.
//

import SwiftUI

struct ToggleCollectibleWallJump: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
            viewModel.showWallJumpBoots.toggle()
            let message = [
                "type": "cmd",
                "key": "showWallJumpBoots",
                "value": viewModel.showWallJumpBoots
            ]
            peerConnection.sendMessage(message)
        }) {
            ZStack {
                Image("walljump")
                    .resizable()
                    .frame(width: size, height: size)
                    .saturation(0)
                    .brightness(0.4)
                Slash(size: size)
                    .opacity(viewModel.showWallJumpBoots ? 0 : 1)
            }
            .opacity(viewModel.lockSettings ? viewModel.lockedSettingOpacity : 1)
        }
        .disabled(viewModel.lockSettings)
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
