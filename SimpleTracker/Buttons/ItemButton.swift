//
//  ItemButton.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

struct ItemButton: View {
    var iconName: String
    @State var collected: Bool

    var body: some View {
        if iconName != "" {
            Image(iconName)
                .resizable()
                .frame(width: 60, height: 60)
                .modifier(AppearanceModifier(type: .item, isActive: collected))
                .gesture(
                    TapGesture()
                        .onEnded {
                            collected.toggle()
                            defaults.set(collected, forKey: iconName)
                        }
                )
        } else {
            Rectangle()
                .fill(Color.black)
                .frame(width: 60, height: 60)
        }
    }
}

