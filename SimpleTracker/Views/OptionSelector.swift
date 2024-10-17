//
//  OptionSelector.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/7/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct OptionSelector: View {
    @Environment(ViewModel.self) private var viewModel
    @State var seedOption: SeedOption
    
    init (seedOption: SeedOption) {
        self.seedOption = seedOption
    }

    private func getColor(idx: Int, colors: [UInt]) -> UInt {
        if idx > colors.count - 1 {
            return colors[colors.count - 1]
        } else {
            return colors[idx]
        }
    }
    
    var body: some View {
        VStack(spacing: viewModel.seedOptionsSpacing) {
            Text(seedOption.title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: viewModel.seedOptionTitleFontSize))
            Text(seedOption.options[seedOption.selection].uppercased())
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: seedOption.selection, colors: seedOption.colors)))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
        }
            .gesture(
                TapGesture()
                    .onEnded {
                        let selection = (seedOption.selection + 1) % seedOption.options.count
                        seedOption.update(selection)
                    }
            )
    }
}
