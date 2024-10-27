//
//  ItemButton.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/7/24.
//
//  Thanks to Ryan Ashton for the help with SwiftUI and the layout of this file.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct ItemButton: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(PeerConnection.self) private var peerConnection
    @State var item: Item
    var size: CGFloat
    var isActive: Bool

    init(item: Item, size: CGFloat, isActive: Bool) {
        self.item = item
        self.size = size
        self.isActive = isActive
    }
    
    var body: some View {
        if isActive && item.key != .empty {
            ZStack (alignment: .bottomTrailing){
                Image(item.offImage != "" && item.collected == 0 ? item.offImage : item.getKey().toString())
                    .resizable()
                    .interpolation(.none)
                    .frame(width: size, height: size)
                    .modifier(Appearance(type: .item, isActive: !item.darkenImage || item.isCollected() ))
                    .gesture(
                        TapGesture()
                            .onEnded {
                                item.collect()
                                let message = [
                                    "type": "item",
                                    "key": item.getKey().toString(),
                                    "value": [
                                        "amount": item.collected
                                    ]
                                ]
                                peerConnection.sendMessage(message)
                                
                                let seedData = SeedData.create(from: viewModel)
                                seedData.save()
                            }
                    )
                    .gesture( 
                        LongPressGesture()
                            .onEnded { _ in
                                item.decrease()
                                let message = [
                                    "type": "item",
                                    "key": item.getKey().toString(),
                                    "value": [
                                        "amount": item.collected
                                    ]
                                ]
                                peerConnection.sendMessage(message)
                                
                                let seedData = SeedData.create(from: viewModel)
                                seedData.save()
                            }
                    )
                    .onAppear {
                        print("Icon for item '\(item.key)' appeared")
                    }
                if item.isConsumable && item.getCount() > 0 {
                    CountOverlay(count: String(describing: item.getCount()))
                        .frame(alignment: .bottomTrailing)
                }
            }
        } else {
            Rectangle()
                .fill(Color.black)
                .frame(width: size, height: size)
                .onAppear {
                    print("Empty rectangle for item '\(item.getKey().toString()) appeared")
                }
        }
    }
}
