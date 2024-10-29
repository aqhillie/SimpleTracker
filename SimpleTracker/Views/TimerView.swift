//
//  TimerView.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/29/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct LetterBox: View {
    let width: CGFloat?
    var letter: String = "0"
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
//                .baselineOffset(-100)
                .border(.red)
        }
            .clipShape(Rectangle())
            .frame(width: width, alignment: .center)
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
            .baselineOffset(6)
            .font(.custom("BigNoodleTitling", size: size))
            .border(.red)
    }
}

struct TimerView: View {
    @Environment(TimerViewModel.self) private var viewModel
    let fontSize: CGFloat = 72

    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            LetterBox("0", size: fontSize)
                .border(.red)
            LetterBox("0", size: fontSize)
                .border(.red)
            LetterBox(":", size: fontSize, fixed: false)
                .border(.red)
            LetterBox("0", size: fontSize)
                .border(.red)
            LetterBox("0", size: fontSize)
                .border(.red)
            Hundreds("00", size: fontSize / 2)
        }
        .border(.red)
    }
}
