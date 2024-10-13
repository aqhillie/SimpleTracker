//
//  OptionSelector.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

private func getColor(idx: Int, colors: [UInt]) -> UInt {
    if idx > colors.count - 1 {
        return colors[colors.count - 1]
    } else {
        return colors[idx]
    }
}

struct OptionSelectorView: View {
    
    @State var gameOption: Option

    init(gameOption: Option) {
        self.gameOption = gameOption
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(gameOption.title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: 18))
            Text(gameOption.options[gameOption.selection].uppercased())
                .frame(width: 320, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: gameOption.selection, colors: gameOption.colors)))
                .font(.custom("Super Metroid (SNES)", size: 28))
        }
            .gesture(
                TapGesture()
                    .onEnded {
                        let selection = (gameOption.selection + 1) % gameOption.options.count
                        gameOption.update(selection)
                    }
            )
    }
}
