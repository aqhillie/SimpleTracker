#if os(iOS)
//
//  MobileOptions.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/24/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct MobileOptions: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(TimerViewModel.self) private var timerViewModel
    let orientation: Orientation
    
    init(orientation: Orientation = .portrait) {
        self.orientation = orientation
    }

    var body: some View {
        if (orientation == .portrait) {
            VStack {
                Spacer()
                LockSettings()
                Spacer()
                ResetTracker()
                Spacer()
                TimerButton()
                Spacer()
                ToggleEye()
                Spacer()
                ToggleOptionalPhantoon()
                Spacer()
                ToggleCollectibleWallJumpMode()
                Spacer()
                NetworkStatusAndToggle()
                Spacer()
            }
            .padding(0)
        } else {
            HStack {
                Spacer()
                LockSettings()
                Spacer()
                ResetTracker()
                Spacer()
                ToggleEye()
                Spacer()
                ToggleOptionalPhantoon()
                Spacer()
                ToggleCollectibleWallJumpMode()
                Spacer()
                NetworkStatusAndToggle()
                Spacer()
            }
            .padding(0)
        }
    }
}
#endif
