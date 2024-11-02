//
//  TimerData.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 11/1/24.
//

#if os(macOS)
import Foundation

class TimerData: Codable {
    var startTime: Date?
    var stopTime: Date?

    private init(startTime: Date?, stopTime: Date?) {
        self.startTime = startTime
        self.stopTime = stopTime
    }
    
    private static let iso8601WithMilliseconds: ISO8601DateFormatter = {
         let formatter = ISO8601DateFormatter()
         formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
         return formatter
     }()
    
    static func create(from viewModel: TimerViewModel) -> TimerData {
        return TimerData(startTime: viewModel.startTime, stopTime: viewModel.stopTime)
    }

    static func createFromFile() -> TimerData? {
        let fileURL = URL.documentsDirectory.appending(path: "timer.json")
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom { decoder -> Date in
                let dateString = try decoder.singleValueContainer().decode(String.self)
                guard let date = Self.iso8601WithMilliseconds.date(from: dateString) else {
                    throw DecodingError.dataCorruptedError(in: try decoder.singleValueContainer(), debugDescription: "Invalid date format")
                }
                return date
            }
            let timerData: TimerData = try decoder.decode(TimerData.self, from: jsonData)
            debug("Successfully loaded timer data from \(fileURL.path)")
            return timerData
        } catch {
            debug("Failed to read timer data: \(error)")
            return nil
        }
    }
    
    static func exists() -> Bool {
        let fileURL = URL.documentsDirectory.appending(path: "timer.json")
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    func toJSON() -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .custom { date, encoder in
                let dateString = Self.iso8601WithMilliseconds.string(from: date)
                var container = encoder.singleValueContainer()
                try container.encode(dateString)
            }
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            debug("Failed to get JSON from timerData.")
            return nil
        }
    }

    // save timer file
    func save() {
        let fileURL = URL.documentsDirectory.appending(path: "timer.json")

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .custom { date, encoder in
                let dateString = Self.iso8601WithMilliseconds.string(from: date)
                var container = encoder.singleValueContainer()
                try container.encode(dateString)
            }
            let jsonData = try encoder.encode(self)
            try jsonData.write(to: fileURL, options: [.atomic])
            debug("Successfully saved timer data to \(fileURL.path)")
        } catch {
            debug("Failed to write timer data: \(error)")
        }
    }
        
    // Load timer file into passed in ViewModel
    static func loadTimer(into viewModel: TimerViewModel) {
        let fileURL = URL.documentsDirectory.appending(path: "timer.json")
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom { decoder -> Date in
                let dateString = try decoder.singleValueContainer().decode(String.self)
                guard let date = Self.iso8601WithMilliseconds.date(from: dateString) else {
                    throw DecodingError.dataCorruptedError(in: try decoder.singleValueContainer(), debugDescription: "Invalid date format")
                }
                return date
            }
            let timerData: TimerData = try decoder.decode(TimerData.self, from: jsonData)
            debug("Successfully loaded timer data from \(fileURL.path)")
            
            if let startTime = timerData.startTime, let stopTime = timerData.stopTime {
                viewModel.startTime = startTime
                viewModel.stopTime = stopTime
                viewModel.elapsedTime = stopTime.timeIntervalSince(startTime)
            }
        } catch {
            debug("Failed to read timer data: \(error)")
        }
    }}
#endif
