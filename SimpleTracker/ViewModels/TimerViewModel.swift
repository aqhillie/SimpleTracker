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
    var elapsedTime: TimeInterval = 0
    var timer: Timer?
    var isRunning: Bool = false
    var isVisible: Bool = UserDefaults.standard.boolWithDefaultValue(forKey: "timerVisibility", defaultValue: false)
    #endif
    #if os(iOS)
    var isRunning: Bool = false
    var isVisible: Bool = false
    #endif

    #if os(macOS)
    func startTimer() {
        if startTime == nil {
            startTime = Date()
        }
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01666667, repeats: true) { _ in
            self.updateElapsedTime()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func resetTimer() {
        stopTimer()
        elapsedTime = 0
        startTime = nil
    }

    private func updateElapsedTime() {
        guard let startTime = startTime else { return }
        elapsedTime = Date().timeIntervalSince(startTime)
    }
    
    func getIntHours() -> Int {
        return Int(elapsedTime) / 3600
    }
    
    func getHours() -> String {
        let hours = Int(elapsedTime) / 3600
        return String(format: "%02d", hours)
    }

    func getMinutes() -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) / 60) - (hours * 60)
        return String(format: "%02d", minutes)
    }

    func getSeconds() -> String {
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d", seconds)
    }

    func getHundredths() -> String {
        let hundredths = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d", hundredths)
    }
    #endif
}
