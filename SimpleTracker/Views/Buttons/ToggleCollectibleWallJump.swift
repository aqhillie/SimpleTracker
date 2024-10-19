#if os(iOS)
//
//  CollectibleWallJump.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/18/24.
//

import SwiftUI

struct ToggleCollectibleWallJump: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        Button(action: {
            viewModel.collectibleWallJump.toggle()
        }) {
            ZStack {
                Image("walljump")
                    .resizable()
                    .frame(width: 24, height:24)
                    .saturation(0)
                Image(systemName: "nosign")
                    .foregroundColor(.white)
                    .font(.system(size: 32)) // Adjust size as needed
                    .opacity(viewModel.collectibleWallJump ? 1 : 0)
            }
        }
    }
}
#endif
