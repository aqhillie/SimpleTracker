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
    @State var boss: Boss
    @Environment(ViewModel.self) private var viewModel
    
    init (for boss: Boss) {
        self.boss = boss
    }
    
    var body: some View {
        let key = boss.getKey()
        Image(boss.isDead() ? "dead" + key : key)
            .resizable()
            .frame(width: viewModel.bossSize, height: viewModel.bossSize)
            .gesture(
                TapGesture()
                    .onEnded {
                        boss.deathToggle()
                    }
            )
            .modifier(Appearance(type: .boss, isActive: boss.isDead()))
    }
}
