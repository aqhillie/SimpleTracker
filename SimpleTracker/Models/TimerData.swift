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
            let timerData: TimerData = try JSONDecoder().decode(TimerData.self, from: jsonData)
            debug("Successfully loaded timer data from \(fileURL.path)")
            return timerData
        } catch {
            debug("Failed to read seed data: \(error)")
            return nil
        }
    }
    
    static func exists() -> Bool {
        let fileURL = URL.documentsDirectory.appending(path: "timer.json")
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    func toJSON() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
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
            let jsonData = try JSONEncoder().encode(self)
            try jsonData.write(to: fileURL, options: [.atomic])
            debug("Successfully saved seed data to \(fileURL.path)")
        } catch {
            debug("Failed to write timer data: \(error)")
        }
    }
        
    // Load seed file into passed in ViewModel
    static func loadTimer(into viewModel: TimerViewModel) {
        let fileURL = URL.documentsDirectory.appending(path: "timer.json")
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let timerData: TimerData = try JSONDecoder().decode(TimerData.self, from: jsonData)
            debug("Successfully loaded timer data from \(fileURL.path)")
            
            viewModel.startTime = timerData.startTime
            viewModel.stopTime = timerData.stopTime
        } catch {
            debug("Failed to read timer data: \(error)")
        }
    }
}
#endif
