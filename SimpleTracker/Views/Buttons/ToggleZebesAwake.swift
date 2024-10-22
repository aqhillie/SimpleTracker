//
//  CollectibleWallJump.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/18/24.
//

import SwiftUI

struct ToggleEye: View {
    @Environment(ViewModel.self) private var viewModel
    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
            viewModel.showEye.toggle()
        }) {
            ZStack {
                Image("eye")
                    .resizable()
                    .frame(width: size, height: size)
                    .saturation(0)
                    .brightness(0.4)
                Slash(size: size)
                    .opacity(viewModel.showEye ? 0 : 1)
            }
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
