//
//  TimerButton.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/29/24.
//

import SwiftUI

struct TimerButton: View {
    @Environment(ViewModel.self) private var appViewModel
    @Environment(TimerViewModel.self) private var viewModel

    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
            #if os(macOS)
            if viewModel.isRunning {
                viewModel.stopTimer()
            } else {
                viewModel.startTimer()
            }
            #endif
        }) {
            Image(systemName: "stopwatch")
                .font(.system(size: size)) // Optional: Adjust the size
                .foregroundColor(.white)  // Optional: Change the color
        }
        .disabled(!viewModel.isVisible)
        .opacity(viewModel.isVisible ? 1 : appViewModel.lockedSettingOpacity)
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
