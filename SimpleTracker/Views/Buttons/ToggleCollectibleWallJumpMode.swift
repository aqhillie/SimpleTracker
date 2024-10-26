//
//  CollectibleWallJump.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/18/24.
//

import SwiftUI

struct ToggleCollectibleWallJumpMode: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        Button(action: {
            viewModel.collectibleWallJumpMode = (viewModel.collectibleWallJumpMode + 1) % 4
        }) {
            ZStack {
                switch(viewModel.collectibleWallJumpMode) {
                    case 0:
                        Image("canwalljump")
                            .resizable()
                            .frame(width: size * 1.25, height: size * 1.25)
                            .padding(.bottom, size * 0.25)
                            .padding(.trailing, size * 0.6)
                            .saturation(0)
                            .brightness(0.4)
                        Image("walljump")
                            .resizable()
                            .frame(width: size / 2, height: size / 2)
                            .padding(.top, size / 2)
                            .padding(.leading, size / 2)
                            .saturation(0)
                            .brightness(0.4)
                        Slash(size: size)
                    case 1:
                        Image("walljump")
                            .resizable()
                            .frame(width: size, height: size)
                            .saturation(0)
                            .brightness(0.4)
                    case 2:
                        Image("canwalljump")
                            .resizable()
                            .frame(width: size, height: size)
                            .saturation(0)
                            .brightness(0.4)
                    case 3:
                        Image("canwalljump")
                            .resizable()
                            .frame(width: size * 1.25, height: size * 1.25)
                            .padding(.bottom, size * 0.25)
                            .padding(.trailing, size * 0.6)
                            .saturation(0)
                            .brightness(0.4)
                        Image("walljump")
                            .resizable()
                            .frame(width: size / 2, height: size / 2)
                            .padding(.top, size / 2)
                            .padding(.leading, size / 2)
                            .saturation(0)
                            .brightness(0.4)
                    default:
                        Rectangle()
                            .backgroundStyle(.red)
                            .frame(width: size, height: size)
                    }
            }
            .frame(width: size, height: size)
            .clipShape(Rectangle())
            .opacity(viewModel.broadcastMode || !viewModel.collectibleWallJump ? viewModel.lockedSettingOpacity : 1)
        }
        .help("Toggle Collectible Wall Jump related icons: None, Wall Jump Boots, Can Wall Jump Icon, Both. (Collectible Wall Jump must be set to Collectible)")
        .disabled(viewModel.broadcastMode || !viewModel.collectibleWallJump)
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
