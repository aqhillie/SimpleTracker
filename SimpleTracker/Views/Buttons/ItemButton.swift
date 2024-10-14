//
//  ItemButton.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

struct ItemButton: View {

    @State var item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    var body: some View {
        if item.isActive {
            ZStack {
                Image(item.name)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .modifier(Appearance(type: .item, isActive: item.getCollection() > 0))
                    .gesture(
                        TapGesture()
                            .onEnded {
                                item.collect()
                                item.userDefaultsSize()
                            }
                    )
                if item.isConsumable {
                    ItemCount(count: String(describing: item.getCollection()))
                        .frame(alignment: .bottomTrailing)
                }
            }
        } else {
            Rectangle()
                .fill(Color.black)
                .frame(width: 60, height: 60)
        }
    }
}
