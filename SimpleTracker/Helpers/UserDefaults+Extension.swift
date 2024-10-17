//
//  UserDefaults+Extension.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/16/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

extension UserDefaults {
    func integerWithDefaultValue(forKey: String, defaultValue: Int) -> Int {
        if (self.object(forKey: forKey) != nil) {
            return self.integer(forKey: forKey)
        } else {
            return defaultValue
        }
    }
    
    func boolWithDefaultValue(forKey: String, defaultValue: Bool) -> Bool {
        if (self.object(forKey: forKey) != nil) {
            return self.bool(forKey: forKey)
        } else {
            return defaultValue
        }
    }
}
