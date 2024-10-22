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
    @Binding var isActive: Bool

    init(item: Item, size: CGFloat, isActive: Binding<Bool>) {
        self.item = item
        self.size = size
        self._isActive = isActive
    }
    
    var body: some View {
        
        if isActive && item.key != "" {
            ZStack (alignment: .bottomTrailing){
                Image(item.offImage != "" && item.collected == 0 ? item.offImage : item.key)
                    .resizable()
                    .frame(width: size, height: size)
                    .modifier(Appearance(type: .item, isActive: !item.darkenImage || item.isCollected() ))
                    .gesture(
                        TapGesture()
                            .onEnded {
                                item.collect()
                                let message = [
                                    "type": "item",
                                    "key": item.key,
                                    "value": item.collected
                                ]
                                peerConnection.sendMessage(message)
                            }
                    )
                    .gesture(
                        LongPressGesture()
                            .onEnded { _ in
                                item.decrease()
                                let message = [
                                    "type": "item",
                                    "key": item.key,
                                    "value": item.collected
                                ]
                                peerConnection.sendMessage(message)
                            }
                    )
                if item.isConsumable && item.getCount() > 0 {
                    CountOverlay(count: String(describing: item.getCount()))
                        .frame(alignment: .bottomTrailing)
                }
            }
        } else {
            Rectangle()
                .fill(Color.black)
                .frame(width: size, height: size)
        }
    }
}
