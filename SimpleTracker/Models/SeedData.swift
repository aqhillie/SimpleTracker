//
//  SeedData.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/27/24.
//
//  Copyright (C) 2024 Warpixel
//

import Foundation

enum SeedDataError: Error {
    case missingSettings
}

class SeedData: Codable {
    var name: String
    var type: String = "SimpleTracker Seed Data File"
    var defeatedBosses: Set<String>
    var collectedItems: [String: Int]
    var settings: [String: Int]
    
    private init(name: String = "main", defeatedBosses: Set<String>, collectedItems: [String: Int], settings: [String: Int]) {
        self.name = name
        self.defeatedBosses = defeatedBosses
        self.collectedItems = collectedItems
        self.settings = settings
    }

    static func create(from viewModel: ViewModel, name: String = "main") -> SeedData {
        var defeatedBosses: Set<String> = Set([])
        var collectedItems: [String: Int] = [:]
        var settings: [String: Int] = [:]
        
        for (key, boss) in viewModel.bosses {
            if boss._isDead {
                defeatedBosses.insert(key.toString())
            }
        }
        
        for (key, item) in viewModel.items {
            if (key == .phantoon && item.collected == 0) {
                collectedItems[key.toString()] = item.collected
            } else if (item.isRealItem && item.collected > 0) {
                collectedItems[key.toString()] = item.collected
            }
        }
        
        settings = [
            "objective": viewModel.objective,
            "difficulty": viewModel.difficulty,
            "itemProgression": viewModel.itemProgression,
            "qualityOfLife": viewModel.qualityOfLife,
            "mapLayout": viewModel.mapLayout,
            "doors": viewModel.doors,
            "startLocation": viewModel.startLocation,
            "collectibleWallJumnp": viewModel.collectibleWallJump ? 1 : 0
        ]
        
        return SeedData(name: name, defeatedBosses: defeatedBosses, collectedItems: collectedItems, settings: settings)
    }
    
    // save seed file
    func save() {
        let fileURL = URL.documentsDirectory.appending(path: "\(self.name).json")

        do {
            let jsonData = try JSONEncoder().encode(self)
            try jsonData.write(to: fileURL, options: [.atomic])
            debug("Successfully saved seed data to \(fileURL.path)")
        } catch {
            debug("Failed to write seed data: \(error)")
        }
    }
    
    // Load seed file into passed in ViewModel
    static func loadSeed(name: String = "main", into viewModel: ViewModel) {
        let fileURL = URL.documentsDirectory.appending(path: "\(name).json")
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let seedData: SeedData = try JSONDecoder().decode(SeedData.self, from: jsonData)
            debug("Successfully loaded seed data from \(fileURL.path)")
            
            for key in seedData.defeatedBosses {
                viewModel.bosses[safe: key.toBossKey()]._isDead = true
            }
            
            for (key, count) in seedData.collectedItems {
                viewModel.items[safe: key.toItemKey()].collected = count
            }

            guard let objective = seedData.settings["objective"],
                  let difficulty = seedData.settings["difficulty"],
                  let itemProgression = seedData.settings["itemProgression"],
                  let qualityOfLife = seedData.settings["qualityOfLife"],
                  let mapLayout = seedData.settings["mapLayout"],
                  let doors = seedData.settings["doors"],
                  let startLocation = seedData.settings["startLocation"],
                  let collectibleWallJump: Bool = seedData.settings["collectibleWallJump"] == 1 ? true: false else {
                throw SeedDataError.missingSettings
            }
            
            viewModel.objective = objective
            viewModel.difficulty = difficulty
            viewModel.itemProgression = itemProgression
            viewModel.qualityOfLife = qualityOfLife
            viewModel.mapLayout = mapLayout
            viewModel.doors = doors
            viewModel.startLocation = startLocation
            viewModel.collectibleWallJump = collectibleWallJump
            
        } catch {
            debug("Failed to read seed data: \(error)")
        }
    }
}
