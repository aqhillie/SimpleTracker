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
    @Environment(PeerConnection.self) private var peerConnection

    let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }

    var body: some View {
        Button(action: {
        }) {
            Image(systemName: "stopwatch")
                .font(.system(size: size)) // Optional: Adjust the size
                .foregroundColor(.white)  // Optional: Change the color
                .onTapGesture {
                    #if os(macOS)
                    if viewModel.isRunning {
                        viewModel.stopTimer()
                    } else {
                        viewModel.startTimer()
                    }
                    let message = [
                        "type": "cmd",
                        "key": "timerRunning",
                        "value": viewModel.isRunning
                    ]
                    peerConnection.sendMessage(message)
                    #elseif os(iOS)
                    let message = [
                        "type": "cmd",
                        "key": "toggleTimer",
                        "value": ""
                    ]
                    peerConnection.sendMessage(message)
                    #endif
                }
                .onLongPressGesture {
                    #if os(macOS)
                    if viewModel.isRunning {
                        viewModel.stopTimer()
                    }
                    viewModel.resetTimer()
                    #elseif os(iOS)
                    let message = [
                        "type": "cmd",
                        "key": "resetTimer",
                        "value": ""
                    ]
                    peerConnection.sendMessage(message)
                    #endif
                }
        }
        .disabled(!viewModel.isVisible)
        #if os(iOS)
        .opacity(viewModel.isVisible && !appViewModel.localMode ? 1 : appViewModel.lockedSettingOpacity)
        #endif
        #if os(macOS)
        .opacity(viewModel.isVisible ? 1 : appViewModel.lockedSettingOpacity)
        .buttonStyle(PlainButtonStyle())
        .focusable(false)
        #endif
    }
}
