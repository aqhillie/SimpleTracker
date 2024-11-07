//
//  LockSettings.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/23/24.
//

import SwiftUI

struct LockSettings: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
            viewModel.broadcastMode.toggle()
            let message = [
                "type": "cmd",
                "key": "broadcastMode",
                "value": viewModel.broadcastMode
            ]
            peerConnection.sendMessage(message)
        }) {
            #if os(macOS)
            Image("bcast-macos")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: size)
                .saturation(viewModel.broadcastMode ? 1 : 0)
                .opacity(viewModel.broadcastMode ? 1 : 0.5)
            #elseif os(iOS)
            ZStack {
                Image("bcast-ios")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .saturation(viewModel.broadcastMode ? 1 : 0)
                    .brightness(viewModel.broadcastMode ? 0 : 0.5)
                Slash(size: size)
                    .opacity(viewModel.broadcastMode ? 0 : 1)
            }
            #endif
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
