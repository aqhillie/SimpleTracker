//
//  ContentView.swift
//  Simple Tracker
//
//  Created by fiftyshadesofurban on 10/6/24.
//
// Copyright (C) 2024 Warpixel
//

import SwiftUI

struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        #if os(macOS)
        ZStack(alignment: .top) {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: viewModel.rootVStackSpacing) {
                Spacer()
                    .frame(height: 30)
//                SeedName()
                HStack(alignment: .top, spacing: viewModel.rootHStackSpacing) {
                    Spacer()
                        .frame(width: 37 - viewModel.rootHStackSpacing)
                    Bosses()
                        .minimumScaleFactor(0.1)
                    ItemGrid()
                    GameOptions()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            TitleBar()
        }
        .edgesIgnoringSafeArea(.top)
        .padding(0)
//        .navigationTitle("\(title) - SimpleTracker")
        #else
        GeometryReader { g in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                if (g.size.width > g.size.height) {
                    VStack {
                        HStack {
                            Spacer()
                            Bosses(g: g)
                                .minimumScaleFactor(0.1)
                            Spacer()
                            ItemGrid(g: g)
                            Spacer()
                            GameOptions(g: g)
                            Spacer()
                        }
                    }
                } else {
                    HStack {
                        VStack {
                            Spacer()
                            Bosses(g: g)
                            Spacer()
                            ItemGrid(g: g)
                            Spacer()
                            GameOptions(g: g)
                            Spacer()
                        }
                    }
                }
            }
            .padding(0)
        }
        #endif
    }
}

#if os(macOS)
struct TitleBar: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        ZStack(alignment: .top) {
            Text("SimpleTracker")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .opacity(viewModel.isWindowActive ? 1 : 0.3)
            HStack {
                Spacer()
                ResetTracker(size: 15)
                LockSettings(size: 15)
                ToggleCollectibleWallJumpMode(size: 15)
                ToggleEye(size: 15)
                NetworkStatusAndToggle(size: 15)
            }
            .opacity(viewModel.isWindowActive ? 1 : 0.3)
        }
        .frame(height: 30)
        .padding(.horizontal, 10)
        .background(viewModel.isWindowActive ? Color.titleActive : Color.titleInactive)
    }
}
#endif
