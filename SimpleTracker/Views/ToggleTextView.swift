//
//  ToggleTextView.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

struct ToggleTextView: View {
    var options: [String]
    @State private var currentIndex = 0

    var body: some View {
        Button(action: {
            // Cycle through the options
            currentIndex = (currentIndex + 1) % options.count
        }) {
            Text(options[currentIndex])
                .font(.headline)
                .foregroundColor(.yellow)  // Customize color as needed
        }
    }
}
