//
//  Globals.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/24/24.
//
// Copyright (C) 2024 Warpixel
//

import Foundation
import AppKit

let appName:String = (Bundle.main.infoDictionary!["CFBundleName"] as? String)!
let appVersion:String = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
let buildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as? String

func resizeWindow(_ x: CGFloat, _ y: CGFloat) {
    if let window = NSApplication.shared.windows.first {
        window.setContentSize(CGSize(width: x, height: y))
    }
}

func resizeWindowToFitContent() {
    resizeWindow(1,1)
}

func debug(_ items: Any...) {
    #if DEBUG
    print(items)
    #endif
}
