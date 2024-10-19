#if os(iOS)
//
//  ResetTracker.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/18/24.
//

import SwiftUI

struct ResetTracker: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        Button(action: {
            viewModel.resetBosses()
            viewModel.resetItems()
        }) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 32)) // Optional: Adjust the size
                .foregroundColor(.white)  // Optional: Change the color
        }
    }
}

#endif
