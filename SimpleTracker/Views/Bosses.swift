//
//  Bosses.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/13/24.
//

import SwiftUI

struct BossBody: View {
    let iconName: String
    @Binding var isDead: Bool
        
    var body: some View {
        Image(isDead ? "dead" + iconName : iconName)
            .resizable()
            .frame(width: 65, height: 65)
            .gesture(
                TapGesture()
                    .onEnded {
                        $isDead.wrappedValue.toggle()
                        print(isDead)
                    }
            )
            .modifier(AppearanceModifier(type: .boss, isActive: isDead))
    }
}

struct BossRidley: View {
    let name: String = "ridley"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        BossBody(iconName: name, isDead: $appState.ridleyDead)
    }
}

struct BossPhantoon: View {
    let name: String = "phantoon"
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        BossBody(iconName: name, isDead: $appState.phantoonDead)
    }
}

struct BossKraid: View {
    let name: String = "kraid"
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        BossBody(iconName: name, isDead: $appState.kraidDead)
    }
}

struct BossDraygon: View {
    let name: String = "draygon"
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        BossBody(iconName: name, isDead: $appState.draygonDead)
    }
}
