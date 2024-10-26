//
//  BossButton.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/6/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct BossButton: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    @State var boss: Boss
    let size: CGFloat
    let deadImage: String
    
    init (for boss: Boss, size: CGFloat) {
        self.boss = boss
        self.size = size
        self.deadImage = boss.deadImage
    }
    
    var body: some View {
        if boss.key != .empty {
            Image(boss.isDead() && deadImage != "" ? deadImage : boss.getKey().toString())
                .resizable()
                .frame(width: size, height: size)
                .gesture(
                    TapGesture()
                        .onEnded {
                            boss.deathToggle()
                            let message = [
                                "type": "boss",
                                "key": boss.getKey().toString(),
                                "value": boss.isDead()
                            ]
                            peerConnection.sendMessage(message)
                        }
                )
                .modifier(Appearance(type: .boss, isActive: boss.isDead()))
        } else {
            Rectangle()
                .fill(Color.black)
                .frame(width: size, height: size)
                .onAppear {
                    print("Empty rectangle for item '\(boss.getKey().toString()) appeared")
                }
        }
    }
}
