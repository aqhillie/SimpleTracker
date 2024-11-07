//
//  Slash.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/20/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct Slash: View {
    let size: CGFloat
    
    init (size: CGFloat) {
        self.size = size * 1.3
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                #if os(iOS)
                .frame(width: 8, height: size)
                #else
                .frame(width: 4, height: size)
                #endif
                .rotationEffect(.degrees(-45)) //
            Rectangle()
                .fill(Color.white)
                .frame(width: 2, height: size)
                .rotationEffect(.degrees(-45))

        }
    }
}
