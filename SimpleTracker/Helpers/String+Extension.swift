//
//  String+Extension.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/25/24.
//
//  Copyright (C) 2024 Warpixel
//

extension String {
    func toBossKey() -> BossKey {
        return BossKey(rawValue: self) ?? .empty
    }
    func toItemKey() -> ItemKey {
        return ItemKey(rawValue: self) ?? .empty
    }
}
