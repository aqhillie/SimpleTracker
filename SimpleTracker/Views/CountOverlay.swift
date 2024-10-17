//
//  ItemCount.swift
//  SimpleTracker
//
//  Created by fiftyshadesofurban on 10/7/24.
//

import SwiftUI

struct ItemCount: View {
    var count: String

    var body: some View {
        Text(count)
            .padding(4)
            .background(.black)
            .foregroundColor(.white)
            .font(.custom("Trebuchet MS", size: 24))
            .frame(alignment: .center)
            .multilineTextAlignment(.trailing)
            .allowsHitTesting(false)
    }
}
