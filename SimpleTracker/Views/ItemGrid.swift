//
//  ItemGrid.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/24/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct ItemGroups: View {
    @Environment(ViewModel.self) private var viewModel
    let group: [Item]
    let size: CGFloat
    let paddingTop: CGFloat
    let paddingLeft: CGFloat
    
    init(group: [Item], size: CGFloat, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0) {
        self.group = group
        self.size = size
        self.paddingTop = paddingTop
        self.paddingLeft = paddingLeft
    }

    var body: some View {
        ForEach(0..<5) { index in
            #if os(iOS)
            if (group[index].key != .phantoon || viewModel.objective != 1) {
                ItemButton(item: group[index], size: size, isActive: group[index].isActive)
            } else {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: size, height: size)
                    .onAppear {
                        debug("Empty rectangle for Phantoon special case appeared.")
                    }
            }
            #else
            ItemButton(item: group[index], size: size, isActive: group[index].isActive)
                .padding(.top, paddingTop)
                .padding(.leading, paddingLeft)
            #endif
        }
    }
}

struct ItemGrid: View {
    @Environment(ViewModel.self) private var viewModel
    #if os(iOS)
    let g: GeometryProxy
       
    init(g: GeometryProxy) {
        self.g = g
    }
    #endif

    
    var body: some View {
        #if os(macOS)
        VStack {
            HStack(spacing: viewModel.itemGridHorizontalSpacing) {
                ForEach(0..<5) { index in
                    VStack(spacing: viewModel.itemGridVerticalSpacing) {
                        ItemGroups(group: viewModel.itemMatrix[index], size: viewModel.itemSize)
                    }
                    .padding(.top, index == 4 ? 25 : 0)
                    .padding(.leading, index == 4 ? 15 : 0)
                }
            }
            .padding(0)
            HStack(spacing: viewModel.itemGridHorizontalSpacing) {
                if (viewModel.objective == 1) {
                    ItemGroups(group: viewModel.sixthItemRowBosses, size: viewModel.itemSize)
                } else {
                    ItemGroups(group: viewModel.sixthItemRowOthers, size: viewModel.itemSize)
                }
            }
            .padding(.top, 20)
        }
        #elseif os(iOS)
        VStack {
            Spacer()
            ForEach(viewModel.itemMatrix, id: \.self) { row in
                HStack {
                    ItemGroups(group: row, size: viewModel.itemSize)
                }
                Spacer()
            }
        }
        .padding(0)
        #endif
    }
}
