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
            viewModel.lockSettings.toggle()
            let message = [
                "type": "cmd",
                "key": "lockSettings",
                "value": viewModel.lockSettings
            ]
            peerConnection.sendMessage(message)
        }) {
            Image(systemName: viewModel.lockSettings ? "lock.fill" : "lock.open.fill")
                .font(.system(size: size))
                .foregroundColor(.white)
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
