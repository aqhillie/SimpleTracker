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

struct OptionSelector: View {
    let key: String
    let title: String
    let options: [String]
    let colors: [UInt]
    @State var selection: Int

    var body: some View {
        VStack(spacing: 10) {
            Text(title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: 18))
            Text(options[selection].uppercased())
                .frame(width: 320, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: selection, colors: colors)))
                .font(.custom("Super Metroid (SNES)", size: 28))
        }
            .gesture(
                TapGesture()
                    .onEnded {
                        selection = (selection + 1) % options.count
                        defaults.set(selection, forKey: key)
                    }
            )
    }
}
