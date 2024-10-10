//
//  BossButton.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

struct BossButton: View {
    var iconName: String
    @State var isDead: Bool

    var body: some View {
        Image(isDead ? "dead" + iconName : iconName)
            .resizable()
            .frame(width: 65, height: 65)
            .gesture(
                TapGesture()
                    .onEnded {
                        isDead.toggle()
                        defaults.set(isDead, forKey: iconName)
                    }
            )
            .modifier(AppearanceModifier(type: .boss, isActive: isDead))
    }
}
