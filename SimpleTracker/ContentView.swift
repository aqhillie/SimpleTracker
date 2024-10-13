//
//  ContentView.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    @State var appSettings = AppSettings()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            HStack(spacing: 20) {
                bosses
                itemGrid
                GameOptions()
                    .environment(appSettings)
            }
        }
        .padding(0)
    }
}

private var bosses: some View {
    VStack(spacing: 30) {
        BossRidley()
        BossPhantoon()
        BossKraid()
        BossDraygon()
    }
    .padding(0)
}

private var itemGrid: some View {
    return HStack(spacing: 12) {
        ForEach(0..<5) { column in
            VStack(spacing: 4) {
                ForEach(0..<6) { row in
                    let itemName = itemNames[column * 6 + row]
                    if (consumables.contains(itemName)) {
                        ConsumableButton(iconName: itemName, collected: (defaults.object(forKey: itemName) != nil) ? defaults.integer(forKey: itemName) : 0)
                    } else {
                        if (itemName == "walljump") {
                            if (collectibleWallJump == true) {
                                ItemButton(iconName: itemName, collected: (defaults.object(forKey: itemName) != nil) ? defaults.bool(forKey: itemName) : false)
                            } else {
                                ItemButton(iconName: "", collected: false)
                            }
                        } else {
                            ItemButton(iconName: itemName, collected: (defaults.object(forKey: itemName) != nil) ? defaults.bool(forKey: itemName) : false)
                        }
                    }
                }
            }
        }
    }
    .padding(0)
}

struct GameOptions: View {
    var body: some View {
        VStack(spacing: 20) {
            SeedObjectiveSelector()
            SeedDifficultySelector()
            SeedItemProgressionSelector()
            SeedQualityOfLifeSelector()
            SeedMapLayoutSelector()
        }
        .background(Color.black)
    }
}

