//
//  TimerButton.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/29/24.
//

import SwiftUI

struct TimerButton: View {
    @Environment(TimerViewModel.self) private var viewModel
    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
            if viewModel.isRunning {
                viewModel.stopTimer()
            } else {
                viewModel.startTimer()
            }
        }) {
            Image(systemName: "stopwatch")
                .font(.system(size: size)) // Optional: Adjust the size
                .foregroundColor(.white)  // Optional: Change the color
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
