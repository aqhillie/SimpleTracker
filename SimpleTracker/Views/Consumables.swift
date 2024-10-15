//
//  EmptyCell.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/13/24.
//


//
//  Items.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/13/24.
//

import SwiftUI

struct ConsumableBody: View {
    let iconName: String
    let maxPacks: Int
    @Binding var collected: Int
        
    private func getItemCount() -> String {
        if ["etank", "reservetank"].contains(iconName) {
            return String(collected)
        } else {
            return String(collected*5)
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(iconName)
                .resizable()
                .frame(width: 60, height: 60)
                .gesture(
                    TapGesture()
                        .onEnded {
                            if collected < maxPacks {
                                $collected.wrappedValue += 1
                            }
                        }
                )
                .onLongPressGesture(perform: {
                    if collected > 0 {
                        $collected.wrappedValue -= 1
                    }
                })
                .modifier(Appearance(type: .consumable, isActive: collected > 0))
            if (collected > 0) {
                ItemCount(count: getItemCount())
                    .frame(alignment: .bottomTrailing)
            }
        }
    }
}

struct Missiles: View {
    let name: String = "missile"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ConsumableBody(iconName: name, maxPacks: AppConstants.maxMissilePacks, collected: $appState.missilesCollected)
    }
}

struct SuperMissiles: View {
    let name: String = "super"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ConsumableBody(iconName: name, maxPacks: AppConstants.maxMissilePacks, collected: $appState.supersCollected)
    }
}

struct PowerBombs: View {
    let name: String = "powerbomb"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ConsumableBody(iconName: name, maxPacks: AppConstants.maxMissilePacks, collected: $appState.powerbombsCollected)
    }
}

struct EnergyTanks: View {
    let name: String = "etank"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ConsumableBody(iconName: name, maxPacks: AppConstants.maxMissilePacks, collected: $appState.etanksCollected)
    }
}

struct ReserveTanks: View {
    let name: String = "reservetank"
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState

        ConsumableBody(iconName: name, maxPacks: AppConstants.maxMissilePacks, collected: $appState.reservetanksCollected)
    }
}
