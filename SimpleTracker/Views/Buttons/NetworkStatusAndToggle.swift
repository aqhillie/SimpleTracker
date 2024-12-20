//
//  NetworkStatusAndToggle.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/20/24.
//

import SwiftUI

struct NetworkStatusAndToggle: View {
    @Environment(ViewModel.self) private var viewModel
    #if os(iOS)
    @Environment(TimerViewModel.self) private var timerViewModel
    #endif
    @Environment(PeerConnection.self) private var peerConnection
    
    let size: CGFloat

    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        Button(action: {
            if (viewModel.localMode) {
                peerConnection.startAdvertisingPeer()
                peerConnection.startBrowsingForPeers()
            } else {
                peerConnection.stopAdvertisingPeer()
                peerConnection.stopBrowsingForPeers()
                peerConnection.disconnectPeer()
                #if os(iOS)
                timerViewModel.isVisible = false
                #endif
            }
            viewModel.localMode.toggle()
        }) {
            Image(systemName: viewModel.localMode ? "wifi.slash" : "wifi")
                    .font(.system(size: size))
                    .foregroundColor(peerConnection.hasConnectedPeers ? .green : .white )
        }
        .disabled(viewModel.broadcastMode)
        #if os(iOS)
        .opacity(viewModel.broadcastMode ? viewModel.lockedSettingOpacity : 1)
        #endif
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
