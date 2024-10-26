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
            if (viewModel.lockSettings) {
                #if os(iOS)
                peerConnection.syncToDesktop()
                #endif
            } else {
                viewModel.resetBosses()
                viewModel.resetItems()
                viewModel.items[safe: .walljump].collected = viewModel.collectibleWallJump ? 0 : 1
                let message = [
                    "type": "cmd",
                    "key": "resetTracker",
                    "value": ""
                ]
                peerConnection.sendMessage(message)
            }
        }) {
            #if os(macOS)
            Image(systemName: "arrow.clockwise")
                .font(.system(size: size)) // Optional: Adjust the size
                .foregroundColor(.white)  // Optional: Change the color
            #elseif os(iOS)
            Image(systemName: viewModel.lockSettings ? "arrow.trianglehead.2.clockwise.rotate.90" : "arrow.clockwise")
                .font(.system(size: size)) // Optional: Adjust the size
                .foregroundColor(.white)  // Optional: Change the color
            #endif
        }
        #if os(macOS)
        .disabled(viewModel.lockSettings)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #elseif (iOS)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: viewModel.longPressDelay)
                .onEnded { _ in
                    peerConnection.syncToDesktop()
                }
        )
        #endif
    }
}
