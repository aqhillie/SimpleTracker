//
//  TimerView.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/29/24.
//
//  Copyright (C) 2024 Warpixel
//

#if os(macOS)
import SwiftUI

struct LetterBox: View {
    let width: CGFloat?
    var letter: String
    let size: CGFloat
    let mini: Bool
    
    init(_ letter: String, size: CGFloat, fixed: Bool = true, mini: Bool = false) {
        self.letter = letter
        self.size = size
        self.width = fixed ? mini ? 24 : 30 : nil
        self.mini = mini
    }

    var body: some View {
        ZStack {
            Text(letter)
                .font(.custom("BigNoodleTitling", size: size))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.lightCyan, Color.medCyan]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
            .clipShape(Rectangle())
            .frame(width: width, alignment: .center)
    }
}

struct FixedWidthWord: View {
    let charArray: [Character]
    let size: CGFloat
    
    init(_ str: String, size: CGFloat) {
        self.charArray = Array(str)
        self.size = size
    }
    
    var body: some View {
        ForEach(Array(charArray.enumerated()), id: \.offset) { index, char in
            LetterBox(String(char), size: size)
                .id(index)
        }
    }
}

struct Hundreds: View {
    let value: String
    let size: CGFloat
    
    init(_ value: String, size: CGFloat) {
        self.value = ".\(value)"
        self.size = size
    }
    
    var body: some View {
        Text(value)
            .frame(width: 60, alignment: .leading)
            .baselineOffset(6)
            .font(.custom("BigNoodleTitling", size: size))
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [Color.lightCyan, Color.medCyan]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}

struct TimerView: View {
    @Environment(TimerViewModel.self) private var viewModel
    let fontSize: CGFloat = 72

    var body: some View {
        HStack(alignment: .bottom, spacing: 1) {
            Spacer()
            if(viewModel.getIntHours() >= 1) {
                FixedWidthWord(viewModel.getHours(), size: fontSize)
                LetterBox(":", size: fontSize, fixed: false)
            }
            FixedWidthWord(viewModel.getMinutes(), size: fontSize)
            LetterBox(":", size: fontSize, fixed: false)
            FixedWidthWord(viewModel.getSeconds(), size: fontSize)
            Hundreds(viewModel.getHundredths(), size: fontSize / 2)
        }
    }
}
#endif
