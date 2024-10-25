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

    func isItemActive(item: Item, viewModel: ViewModel) -> Binding<Bool> {
        @Bindable var viewModel = viewModel

        switch(item.key) {
            case "canwalljump":
                return $viewModel.showCanWallJumpIcon
            case "walljump":
                return $viewModel.showWallJumpBoots
            case "eye":
                return $viewModel.showEye
            case "phantoon":
                let showPhantoon = viewModel.seedOptions[0].selection != 1 && viewModel.showOptionalPhantoonIcon
                return Binding(
                    get: { showPhantoon },
                    set: { _ in } // No-op setter, since we can't bind to a combined expression
                )
            default:
                return .constant(true)
        }
    }

    var body: some View {
        ForEach(0..<5) { index in
            ItemButton(item: group[index], size: size, isActive: isItemActive(item: group[index], viewModel: viewModel))
            #if os(macOS)
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
                        //                .padding(.top, firstRow && index == row.count - 1 ? 10 : 0)
                        //                .padding(.leading, index == row.count - 1 ? 15 : 0)
                        ItemGroups(group: viewModel.items[index], size: viewModel.itemSize)
                    }
                    .padding(.top, index == 4 ? 25 : 0)
                    .padding(.leading, index == 4 ? 15 : 0)
                }
            }
            .padding(0)
            HStack(spacing: viewModel.itemGridHorizontalSpacing) {
                if (viewModel.seedOptions[0].selection == 1) {
                    ItemGroups(group: viewModel.sixthItemRowBosses, size: viewModel.itemSize)
                } else {
                    ItemGroups(group: viewModel.sixthItemRowOthers, size: viewModel.itemSize)
                }
            }
            .padding(.top, 20)
        }
        #else
        VStack {
            Spacer()
            ForEach(viewModel.items, id: \.self) { row in
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
