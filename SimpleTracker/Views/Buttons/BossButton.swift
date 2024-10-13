//
//  BossButton.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

struct BossButton: View {
    
    @State var boss: Boss
    
    init(for boss: Boss) {
        self.boss = boss
    }

    var body: some View {
        let name = boss.getName()
        Image(boss.isDead() ? "dead" + name : name)
            .resizable()
            .frame(width: 65, height: 65)
            .gesture(
                TapGesture()
                    .onEnded {
                        boss.killToggle()
                    }
            )
            .modifier(Appearance(type: .boss, isActive: boss.isDead()))
    }
}
