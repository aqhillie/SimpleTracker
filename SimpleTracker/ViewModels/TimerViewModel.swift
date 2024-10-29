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
    var startTime: Date?
    var elapsedTime: TimeInterval = 0
    var timer: Timer?
    var isRunning: Bool = false
    
    var timeString: String {
        return getTimeString(from: elapsedTime)
    }
            
    func startTimer() {
        startTime = Date()
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
    }

    private func updateElapsedTime() {
        guard let startTime = startTime else { return }
        elapsedTime = Date().timeIntervalSince(startTime)
    }
    
    func getTimeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let hundredths = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        let str = String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
        return str.replacingOccurrences(of: "0", with: "O")
    }
}
