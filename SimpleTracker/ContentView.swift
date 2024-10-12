//
//  ContentView.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    // Application State
    
    @State var appState = AppState()
    
    private var bosses: some View {
        VStack(spacing: 30) {
            ForEach(appState.bossNames, id: \.self) { bossName in
                BossButton(iconName: bossName, isDead: (UserDefaults.standard.object(forKey: bossName) != nil) ? UserDefaults.standard.bool(forKey: bossName) : false)
            }
        }
        .padding(0)
    }
    private var itemGrid: some View {
        return HStack(spacing: 12) {
            ForEach(0..<5) { column in
                VStack(spacing: 4) {
                    ForEach(0..<6) { row in
                        let itemName = appState.itemNames[column * 6 + row]
                        if (appState.consumables.contains(itemName)) {
                            ConsumableButton(iconName: itemName, collected: (UserDefaults.standard.object(forKey: itemName) != nil) ? UserDefaults.standard.integer(forKey: itemName) : 0)
                        } else {
                            if (itemName == "walljump") {
                                if (appState.collectibleWallJump == true) {
                                    ItemButton(iconName: itemName, collected: (UserDefaults.standard.object(forKey: itemName) != nil) ? UserDefaults.standard.bool(forKey: itemName) : false)
                                } else {
                                    ItemButton(iconName: "", collected: false)
                                }
                            } else {
                                ItemButton(iconName: itemName, collected: (UserDefaults.standard.object(forKey: itemName) != nil) ? UserDefaults.standard.bool(forKey: itemName) : false)
                            }
                        }
                    }
                }
            }
        }
        .padding(0)
    }
    private var gameOptions: some View {
        return VStack(spacing: 20) {
            ForEach(appState.configOptions, id: \.title) { option in
                OptionSelector(
                    key: option.key,
                    title: option.title,
                    options: option.options,
                    colors: option.colors,
                    selection: option.selection
                )
            }
        }
        .background(Color.black)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            HStack(spacing: 20) {
                bosses
                itemGrid
                gameOptions
            }
        }
        .padding(0)
    }
}


