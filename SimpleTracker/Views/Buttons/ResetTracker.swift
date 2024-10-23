//
//  ResetTracker.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/18/24.
//

import SwiftUI

struct ResetTracker: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
            viewModel.resetBosses()
            viewModel.resetItems()
            viewModel.canWallJumpItem.collected = viewModel.collectibleWallJump ? 0 : 1
            viewModel.wallJumpBootsItem.collected = viewModel.collectibleWallJump ? 0 : 1
            let message = [
                "type": "cmd",
                "key": "resetTracker",
                "value": ""
            ]
            peerConnection.sendMessage(message)
        }) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: size)) // Optional: Adjust the size
                .foregroundColor(.white)  // Optional: Change the color
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
