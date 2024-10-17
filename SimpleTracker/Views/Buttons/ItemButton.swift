//
//  ItemButton.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

struct ItemButton: View {
    @Environment(ViewModel.self) private var viewModel
    @State var item: Item
    @Binding var isActive: Bool

    init(item: Item, isActive: Binding<Bool>) {
        self.item = item
        self._isActive = isActive
    }
    
    var body: some View {
        
        if isActive && item.key != "" {
            ZStack (alignment: .bottomTrailing){
                Image(item.key)
                    .resizable()
                    .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                    .modifier(Appearance(type: .item, isActive: item.isCollected() ))
                    .gesture(
                        TapGesture()
                            .onEnded {
                                item.collect()
                            }
                    )
                    .gesture(
                        LongPressGesture()
                            .onEnded { _ in
                                item.decrease()
                            }
                    )
                if item.isConsumable && item.getCount() > 0 {
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
