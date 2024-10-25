//
//  Bosses.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/24/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct BossLayout: View {
    let bosses: [Boss]
    let size: CGFloat
    
    init(bosses: [Boss], size: CGFloat) {
        self.bosses = (bosses.count > 0) ? bosses : [EmptyBoss(), EmptyBoss(), EmptyBoss(), EmptyBoss()]
        self.size = size
    }
    
    var body: some View {
        #if os(iOS)
        Spacer()
        #endif
        ForEach(bosses, id: \.id) { boss in
            BossButton(for: boss, size: size)
            #if os(iOS)
            Spacer()
            #endif
        }
    }
}

struct Bosses: View {
    @Environment(ViewModel.self) private var viewModel
    #if os(iOS)
    let g: GeometryProxy
    #endif
        
    var body: some View {
        #if os(macOS)
        VStack(spacing: viewModel.bossVerticalSpacing) {
            BossLayout(bosses: viewModel.bosses[viewModel.seedOptions[0].selection], size: viewModel.bossSize)
        }
        .padding(.top, viewModel.bosses[viewModel.seedOptions[0].selection].count > 4 ? 0 : 35)
        #else
        if (g.size.width > g.size.height) {
            VStack {
                BossLayout(bosses: viewModel.bosses[viewModel.seedOptions[0].selection], size: viewModel.bossSize)
            }
            .padding(0)
        } else {
            HStack {
                BossLayout(bosses: viewModel.bosses[viewModel.seedOptions[0].selection], size: viewModel.bossSize)
            }
            .padding(0)
        }
        #endif
    }
}
