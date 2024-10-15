// 
//  Item.swift
//  SimpleTracker
//
//  Created by Ryan Ashton on 13/10/2024 at 12:57 PM
//  Copyright © 2024 Ryan Ashton. All rights reserved.
//
    

import SwiftUI

@Observable
class Item: Identifiable {
    
    let id = UUID()
    
    let name: String
    var collection: Int = 0 {
        didSet {
            UserDefaults.standard.set(collection, forKey: name)
        }
    }
    var maxValue: Int = .max
    let multiplier: Int
    let isConsumable: Bool
    var isActive: Bool {
        didSet {
            UserDefaults.standard.set(isActive, forKey: "\(name)_isActive")
        }
    }
    
    init(name: String, maxValue: Int = 1, multiplier: Int = 1, isActive: Bool = true) {
        self.name = name
        self.collection = UserDefaults.standard.integer(forKey: name)
        self.maxValue = maxValue
        self.multiplier = multiplier
        self.isConsumable = (maxValue == 1 ? false : true )
        self.isActive = name == "" ? false : isActive
        
    }
    
    func collect() {
        switch isConsumable {
            case true:
                if collection < maxValue {
                    collection += multiplier
                }
            case false:
                if collection == 0 {
                    collection += 1
                } else {
                    collection -= 1
                }
        }
    }
    
    func getCollection() -> Int {
        return collection
    }
    
    func reset() {
        collection = 0
    }

    func userDefaultsSize() {
        let items = UserDefaults.standard.dictionaryRepresentation()
        var dictionary: [String: Codable] = [:]
        for (key, value) in items {
            if let newValue = value as? Codable {
                dictionary[key] = newValue
            } else{
                print()
            }
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            print("UserDefaults is: \(data.count) bytes.")
        } catch {
            print("Error serializing UserDefaults: \(error)")
        }
    }
    
}
