//
//  NetworkStatusAndToggle.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/20/24.
//

import SwiftUI

struct NetworkStatusAndToggle: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    @State var localMode: Bool = UserDefaults.standard.boolWithDefaultValue(forKey: "localMode", defaultValue: false)
    
    let size: CGFloat

    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        Button(action: {
            if (localMode) {
                peerConnection.startAdvertisingPeer()
                peerConnection.startBrowsingForPeers()
            } else {
                peerConnection.stopAdvertisingPeer()
                peerConnection.stopBrowsingForPeers()
                peerConnection.disconnectPeer()
            }
            localMode.toggle()
            UserDefaults.standard.set(localMode, forKey: "localMode")
        }) {
            Image(systemName: localMode ? "wifi.slash" : "wifi")
                    .font(.system(size: size))
                    .foregroundColor(peerConnection.hasConnectedPeers ? .green : .white )
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
