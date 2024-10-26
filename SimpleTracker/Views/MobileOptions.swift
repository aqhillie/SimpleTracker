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
    let orientation: Orientation
    
    init(orientation: Orientation = .portrait) {
        self.orientation = orientation
    }

    var body: some View {
        if (orientation == .portrait) {
            VStack {
                Spacer()
                ResetTracker()
                Spacer()
                LockSettings()
                Spacer()
                ToggleCollectibleWallJumpMode()
                Spacer()
                ToggleEye()
                Spacer()
                NetworkStatusAndToggle()
                Spacer()
            }
            .padding(0)
        } else {
            HStack {
                Spacer()
                ResetTracker()
                Spacer()
                LockSettings()
                Spacer()
                ToggleCollectibleWallJumpMode()
                Spacer()
                ToggleEye()
                Spacer()
                NetworkStatusAndToggle()
                Spacer()
            }
            .padding(0)
        }
    }
}
#endif
