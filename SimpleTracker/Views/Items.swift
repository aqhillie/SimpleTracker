//
//  Items.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/13/24.
//

import SwiftUI

struct EmptyCell: View {
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .frame(width: 60, height: 60)
    }
}

struct ItemBody: View {
    let iconName: String
    @Binding var collected: Bool
        
    var body: some View {
        Image(iconName)
            .resizable()
            .frame(width: 60, height: 60)
            .gesture(
                TapGesture()
                    .onEnded {
                        $collected.wrappedValue.toggle()
                    }
            )
            .modifier(Appearance(type: .item, isActive: collected))
    }
}

struct ChargeBeam: View {
    let name: String = "charge"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.chargeBeamCollected)
    }
}

struct IceBeam: View {
    let name: String = "ice"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.iceBeamCollected)
    }
}

struct WaveBeam: View {
    let name: String = "wave"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.waveBeamCollected)
    }
}

struct Spazer: View {
    let name: String = "spazer"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.spazerCollected)
    }
}

struct PlasmaBeam: View {
    let name: String = "plasma"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.plasmaBeamCollected)
    }
}

struct VariaSuit: View {
    let name: String = "varia"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.variaSuitCollected)
    }
}

struct GravitySuit: View {
    let name: String = "gravity"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.gravitySuitCollected)
    }
}

struct GrappleBeam: View {
    let name: String = "grapple"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.grappleBeamCollected)
    }
}

struct XRayScope: View {
    let name: String = "xray"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.xrayScopeCollected)
    }
}

struct MorphBall: View {
    let name: String = "morph"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.morphBallCollected)
    }
}

struct MorphBallBomb: View {
    let name: String = "bomb"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.bombCollected)
    }
}

struct SpringBall: View {
    let name: String = "springball"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.springballCollected)
    }
}

struct ScrewAttack: View {
    let name: String = "screw"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.screwAttackCollected)
    }
}

struct HiJumpBoots: View {
    let name: String = "hijump"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.hijumpCollected)
    }
}

struct SpaceJump: View {
    let name: String = "space"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.spaceJumpCollected)
    }
}

struct SpeedBooster: View {
    let name: String = "speed"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ItemBody(iconName: name, collected: $appState.speedBoosterCollected)
    }
}

struct WallJump: View {
    let name: String = "walljump"
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    
    var body: some View {
        @Bindable var appState = appState

        if (appSettings.collectibleWallJump) {
            ItemBody(iconName: name, collected: $appState.walljumpCollected)
        } else {
            EmptyCell()
        }
    }
}
