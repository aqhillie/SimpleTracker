//
//  ContentView.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var viewModel: ViewModel
    
    init(appState: ViewModel) {
        self.viewModel = appState
    }
    
    private var bosses: some View {
        VStack(spacing: 30) {
            ForEach(viewModel.bosses, id: \.self) { boss in
                BossButton(for: boss)
            }
        }
        .padding(0)
    }
    private var itemGrid: some View {
        return HStack(spacing: 12) {
            ForEach(0..<5) { column in
                VStack(spacing: 4) {
                    ForEach(0..<6) { row in
                        @Bindable var item = viewModel.items[column * 6 + row]
                        ItemButton(item: item)
                    }
                }
            }
        }
        .padding(0)
    }
    private var gameOptions: some View {
        return VStack(spacing: 20) {
            ForEach(viewModel.options, id: \.title) { option in
                @State var option = option
                OptionSelectorView(gameOption: option)
            }
        }
        .background(Color.black)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            HStack(spacing: 20) {
                bosses
                itemGrid
                gameOptions
            }
        }
        .padding(0)
    }
}

