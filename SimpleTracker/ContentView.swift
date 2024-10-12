//
//  ContentView.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    //@State var charge: Item = Item(name: "charge", maxValue: 4)
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
                        @Bindable var item = appState.items[column * 6 + row]
                        switch item.isConsumable {
                            case true:
                                ZStack(alignment: .bottomTrailing) {
                                    Image(item.name)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .gesture(
                                            TapGesture()
                                                .onEnded {
                                                    item.collect()
                                                }
                                        )
                                        .gesture(
                                            LongPressGesture()
                                                .onEnded { _ in
                                                    item.reset()
                                                }
                                        )
                                        .modifier(
                                            AppearanceModifier(type: .item, isActive: item.getCollection() > 0)
                                        )
                                    ItemCount(count: String(describing: item.getCollection()))
                                        .frame(alignment: .bottomTrailing)
                                }
                                .frame(width: 60, height: 60)
                            case false:
                                if (item.name == "walljump") {
                                    if (appState.collectibleWallJump == true) {
                                        //ItemButton(iconName: item.name, collected: item.getCollection() > 0)
                                        ItemButton(item: item)
                                    } else {
                                        ItemButton(item: item)
                                        //ItemButton(iconName: "", collected: false)
                                    }
                                } else {
                                    ItemButton(item: item)
                                    //ItemButton(iconName: item.name, collected: item.getCollection() > 0)
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

