//
//  OptionSelector.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

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
                .foregroundStyle(OptionStyle(gameOption))
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
