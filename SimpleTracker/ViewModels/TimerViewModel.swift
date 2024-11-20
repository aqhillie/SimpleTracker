//
//  TimerViewModel.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/29/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

@Observable
class TimerViewModel {
    #if os(macOS)
    var startTime: Date?
    var stopTime: Date?
    var elapsedTime: TimeInterval = 0
    var timer: Timer?
    var isRunning: Bool = false
    var isVisible: Bool = UserDefaults.standard.boolWithDefaultValue(forKey: "timerVisibility", defaultValue: false)
    var isEditing: Bool = false
    
    // time editor values
    var editHours: Int = 0
    var editMinutes: Int = 0
    var editSeconds: Int = 0
    
    #endif
    #if os(iOS)
    var isRunning: Bool = false
    var isVisible: Bool = false
    #endif

    #if os(macOS)
    func startTimer() {
        if let stopTime, let startTime {
            let elapsedTime = stopTime.timeIntervalSince(startTime)
            self.startTime = Date().addingTimeInterval(-elapsedTime)
        } else {
            startTime = Date()
        }
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01666667, repeats: true) { _ in
            self.updateElapsedTime()
        }
        
        self.save()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        stopTime = Date()
        isRunning = false
        self.save()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        elapsedTime = 0
        startTime = nil
        stopTime = nil
        self.save()
    }

    func updateElapsedTime(withValues: Bool = false) {
        if (withValues) {
            elapsedTime = TimeInterval(editHours * 3600 + editMinutes * 60 + editSeconds)
            startTime = Date().addingTimeInterval(-elapsedTime)
            stopTime = Date()
        } else {
            guard let startTime = startTime else { return }
            elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    func prepareTimeEditor() {
        editHours = getIntHours()
        editMinutes = getIntMinutes()
        editSeconds = getIntSeconds()
    }
    
    func getIntHours() -> Int {
        return Int(elapsedTime) / 3600
    }
    
    func getHours() -> String {
        let hours = Int(elapsedTime) / 3600
        return String(hours)
    }

    func getIntMinutes() -> Int {
        return Int(elapsedTime) / 60 - (getIntHours() * 60)
    }
    
    func getMinutes() -> String {
        let format = getIntHours() > 0 ? "%02d" : "%d"
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) / 60) - (hours * 60)
        return String(format: format, minutes)
    }

    func getIntSeconds() -> Int {
        return Int(elapsedTime) % 60
    }
    
    func getSeconds() -> String {
        let format = getIntMinutes() > 0 ? "%02d" : "%d"
        let seconds = Int(elapsedTime) % 60
        return String(format: format, seconds)
    }

    func getHundredths() -> String {
        let hundredths = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d", hundredths)
    }
    
    func save() {
        let timerData = TimerData.create(from: self)
        timerData.save()
    }
    #endif
}
