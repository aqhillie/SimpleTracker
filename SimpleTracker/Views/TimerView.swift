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
    let viewModel: TimerViewModel
    
    init(_ letter: String, size: CGFloat, fixed: Bool = true, mini: Bool = false, viewModel: TimerViewModel) {
        self.letter = letter
        self.size = size
        self.width = fixed ? mini ? 24 : 30 : nil
        self.mini = mini
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Text(letter)
                .font(.custom("BigNoodleTitling", size: size))
                .foregroundStyle(
                    viewModel.elapsedTime > 0 ?
                    viewModel.isRunning ?
                    LinearGradient(
                        gradient: Gradient(colors: [Color.lightCyan, Color.medCyan]),
                        startPoint: .top,
                        endPoint: .bottom
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [Color.lightGold, Color.medGold]),
                        startPoint: .top,
                        endPoint: .bottom
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [Color.lightSilver, Color.medSilver]),
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
    let viewModel: TimerViewModel

    init(_ str: String, size: CGFloat, viewModel: TimerViewModel) {
        self.charArray = Array(str)
        self.size = size
        self.viewModel = viewModel
    }
    
    var body: some View {
        ForEach(Array(charArray.enumerated()), id: \.offset) { index, char in
            LetterBox(String(char), size: size, viewModel: viewModel)
                .id(index)
        }
    }
}

struct Hundreds: View {
    let value: String
    let size: CGFloat
    let viewModel: TimerViewModel

    init(_ value: String, size: CGFloat, viewModel: TimerViewModel) {
        self.value = ".\(value)"
        self.size = size
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(value)
            .frame(width: 60, alignment: .leading)
            .baselineOffset(6)
            .font(.custom("BigNoodleTitling", size: size))
            .foregroundStyle(
                viewModel.elapsedTime > 0 ?
                viewModel.isRunning ?
                LinearGradient(
                    gradient: Gradient(colors: [Color.lightCyan, Color.medCyan]),
                    startPoint: .top,
                    endPoint: .bottom
                ) :
                LinearGradient(
                    gradient: Gradient(colors: [Color.lightGold, Color.medGold]),
                    startPoint: .top,
                    endPoint: .bottom
                ) :
                LinearGradient(
                    gradient: Gradient(colors: [Color.lightSilver, Color.medSilver]),
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
                FixedWidthWord(viewModel.getHours(), size: fontSize, viewModel: viewModel)
                LetterBox(":", size: fontSize, fixed: false, viewModel: viewModel)
            }
            if(viewModel.getIntMinutes() >= 1) {
                FixedWidthWord(viewModel.getMinutes(), size: fontSize, viewModel: viewModel)
                LetterBox(":", size: fontSize, fixed: false, viewModel: viewModel)
            }
            FixedWidthWord(viewModel.getSeconds(), size: fontSize, viewModel: viewModel)
            Hundreds(viewModel.getHundredths(), size: fontSize / 2, viewModel: viewModel)
        }
    }
}
#endif
