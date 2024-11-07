//
//  String+Extension.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/25/24.
//
//  Copyright (C) 2024 Warpixel
//

import Foundation

extension String {
    func toBossKey() -> BossKey {
        return BossKey(rawValue: self) ?? .empty
    }
    func toItemKey() -> ItemKey {
        return ItemKey(rawValue: self) ?? .empty
    }
    func toSeedData() -> SeedData? {
        do {
            guard let jsonData = self.data(using: .utf8) else { return nil }
            let seedData: SeedData = try JSONDecoder().decode(SeedData.self, from: jsonData)
            return seedData
        } catch {
            return nil
        }
    }
}
