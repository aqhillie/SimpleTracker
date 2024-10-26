//
//  Dictionary+Extension.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/25/24.
//
//  Copyright (C) 2024 Warpixel
//

extension Dictionary where Key == BossKey, Value == Boss {
    subscript(safe key: Key) -> Value {
        return self[key] ?? Boss.emptyBoss
    }
}

extension Dictionary where Key == ItemKey, Value == Item {
    subscript(safe key: Key) -> Value {
        return self[key] ?? Item.emptyItem
    }
}

extension Dictionary where Key == ItemKey, Value == Bool {
    subscript(safe key: Key) -> Value {
        return self[key] ?? true
    }
}
