//
//  ItemButton.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

struct ItemButton: View {
    @State var item: Item
    @Environment(ViewModel.self) private var viewModel

    init(item: Item) {
        self.item = item
    }
    
    var body: some View {
        
        if item.isActive {
            ZStack {
                Image(item.key)
                    .resizable()
                    .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                    .modifier(Appearance(type: .item, isActive: item.isCollected() ))
                    .gesture(
                        TapGesture()
                            .onEnded {
                                print("tappa")
                                print(item.collected > 0)
                                item.collect()
                                print(item.collected > 0)
                            }
                    )
                    .gesture(
                        LongPressGesture()
                            .onEnded { _ in
                                print("long tappa")
                                item.decrease()
                            }
                    )
                if item.isConsumable {
                    ItemCount(count: String(describing: item.getCount()))
                        .frame(alignment: .bottomTrailing)
                }
            }
        } else {
            Rectangle()
                .fill(Color.black)
                .frame(width: viewModel.itemSize, height: viewModel.itemSize)
        }
    }
}
