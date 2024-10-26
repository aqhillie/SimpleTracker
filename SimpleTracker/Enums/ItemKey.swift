//
//  ItemKey.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/25/24.
//
//  Copyright (C) 2024 Warpixel
//

enum ItemKey: String {
    case empty
    case bomb
    case charge
    case grapple
    case gravity
    case hijump
    case ice
    case morph
    case plasma
    case screw
    case space
    case spazer
    case speed
    case springball
    case varia
    case walljump
    case wave
    case xray
    case etank
    case missile
    case powerbomb
    case reservetank
    case supers
    case canwalljump
    case eye
    case phantoon
    
    func toString() -> String {
        return self.rawValue
    }
}
