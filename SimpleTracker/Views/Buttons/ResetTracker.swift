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
    
    @State private var showConfirmationDialog = false

    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
            showConfirmationDialog = true
        }) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: size)) // Optional: Adjust the size
                .foregroundColor(.white)  // Optional: Change the color
        }
        .alert(isPresented: $showConfirmationDialog) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("This action will reset your progress for this seed to zero.\n\nThis cannot be undone."),
                primaryButton: .destructive(Text("Confirm")) {
                    viewModel.resetBosses()
                    viewModel.resetItems()
                    viewModel.items[safe: .walljump].collected = viewModel.collectibleWallJump ? 0 : 1
                    let message = [
                        "type": "cmd",
                        "key": "resetTracker",
                        "value": ""
                    ]
                    peerConnection.sendMessage(message)
                    
                    let seedData = SeedData.create(from: viewModel)
                    seedData.save()
                },
                secondaryButton: .cancel()
            )
        }
        .disabled(viewModel.broadcastMode)
        .opacity(viewModel.broadcastMode ? viewModel.lockedSettingOpacity : 1)
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
