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
    @Environment(PeerConnection.self) private var peerConnection
    let key: String
    let title: String
    let options: [String]
    let colors: [UInt]
    @Binding var selection: Int
    
    init (key: String, title: String, options: [String], colors: [UInt] = [0x808080], selection: Binding<Int>) {
        self.key = key
        self.title = title
        self.options = options
        self.colors = colors
        self._selection = selection
    }
    
    private func getColor(idx: Int) -> UInt {
        if idx > colors.count - 1 {
            return colors[colors.count - 1]
        } else {
            return colors[idx]
        }
    }
    
    var body: some View {
        #if os(macOS)
        VStack(spacing: viewModel.seedOptionsSpacing) {
            Text(title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: viewModel.seedOptionTitleFontSize))
            Text(options[selection].uppercased())
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: selection)))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
        }
            .gesture(
                TapGesture()
                    .onEnded {
                        if (!viewModel.broadcastMode) {
                            selection = (selection + 1) % options.count
                            let message = [
                                "type": "cmd",
                                "key": key,
                                "value": selection
                            ] as [String: Any]
                            
                            peerConnection.sendMessage(message)
                            
                            let seedData = SeedData.create(from: viewModel)
                            seedData.save()
                        }
                    }
            )
        #elseif os(iOS)
        VStack {
            Text(title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: viewModel.seedOptionTitleFontSize))
            Spacer()
                .frame(minHeight: 2, maxHeight: 5)
            Text(options[selection].uppercased())
                .frame(width: viewModel.seedOptionsWidth, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: selection)))
                .font(.custom("SuperMetroidSNES", size: viewModel.seedOptionSelectionFontSize))
            Spacer()
                .frame(minHeight: 0, maxHeight: 20)
        }
        .opacity(viewModel.broadcastMode ? viewModel.lockedSettingOpacity : 1)
            .gesture(
                TapGesture()
                    .onEnded {
                        if (!viewModel.broadcastMode) {
                            selection = (selection + 1) % options.count
                            let message = [
                                "type": "cmd",
                                "key": key,
                                "value": selection
                            ] as [String: Any]
                            
                            peerConnection.sendMessage(message)
                            
                            let seedData = SeedData.create(from: viewModel)
                            seedData.save()
                        }
                    }
            )
        #endif
    }
}
