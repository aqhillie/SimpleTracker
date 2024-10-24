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
                ToggleCollectibleWallJump(size: 15)
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

struct ItemRows: View {
    @Environment(ViewModel.self) private var viewModel
    let row: [Item]
    let size: CGFloat
    let firstRow: Bool
    
    init(row: [Item], size: CGFloat, firstRow: Bool = false) {
        self.row = row
        self.size = size
        self.firstRow = firstRow
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
            ItemButton(item: row[index], size: size, isActive: isItemActive(item: row[index], viewModel: viewModel))
            #if os(macOS)
                .padding(.top, firstRow && index == row.count - 1 ? 20 : 0)
                .padding(.leading, index == row.count - 1 ? 15 : 0)
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
        let sixthItemRow = viewModel.seedOptions[0].selection == 1 ? viewModel.sixthItemRowBosses : viewModel.sixthItemRowOthers
        VStack(spacing: viewModel.itemGridVerticalSpacing) {
            ForEach(0..<5) { index in
                HStack(spacing: viewModel.itemGridHorizontalSpacing) {
                    ItemRows(row: viewModel.items[index], size: viewModel.itemSize, firstRow: index == 0)
                }
            }
            HStack(spacing: viewModel.itemGridHorizontalSpacing) {
                ItemRows(row: sixthItemRow, size: viewModel.itemSize)
            }
            .padding(.top, 20)
        }
        .padding(0)
        #else
        VStack {
            Spacer()
            ForEach(viewModel.items, id: \.self) { row in
                HStack {
                    ItemRows(row: row, size: viewModel.itemSize)
                }
                Spacer()
            }
        }
        .padding(0)
        #endif
    }
}

struct GameOptions: View {
    @Environment(ViewModel.self) private var viewModel
    #if os(iOS)
    let g: GeometryProxy
    #endif
    
    var body: some View {
        #if os(macOS)
        SeedOptions()
        .background(Color.black)
        #else
        if g.size.width > g.size.height {
            VStack {
                Spacer()
                #if os(iOS)
                MobileOptions(orientation: .landscape)
                    .minimumScaleFactor(0.1)
                Spacer()
                #endif
                SeedOptions()
                    .minimumScaleFactor(0.1)
                Spacer()
            }
            .background(Color.black)
        } else {
            HStack {
                SeedOptions()
                    .minimumScaleFactor(0.1)
                #if os(iOS)
                Spacer()
                MobileOptions()
                    .minimumScaleFactor(0.1)
                Spacer()
                #endif
            }
            .background(Color.black)
        }
        #endif
    }
}

struct SeedOptions: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        
        #if os(macOS)
        VStack(spacing: viewModel.seedOptionVStackSpacing) {
            ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                if (seedOption.visible) {
                    OptionSelector(seedOption: seedOption)
                }
            }
        }
        #else
        ScrollView {
            VStack(spacing: 10) {
                ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                    if (seedOption.visible) {
                        OptionSelector(seedOption: seedOption)
                    }
                }
                OptionSelectorMini(key: "collectibleWallJump", title: "Collectible Wall Jump", colors: [0x066815, 0x5B0012], options: ["Vanilla", "Collectible"], selection: viewModel.collectibleWallJump ? 1 : 0, setting: $viewModel.collectibleWallJump)
                OptionSelectorMini(key: "showOptionalPhantoonIcon", title: "Optional Phantoon Icon", colors: [0x808080], options: ["Disabled", "Enabled"], selection: viewModel.showOptionalPhantoonIcon ? 1 : 0, setting: $viewModel.showOptionalPhantoonIcon)
                OptionSelectorMini(key: "showCanWallJumpIcon", title: "Can Wall Jump Icon", colors: [0x808080], options: ["Disabled", "Enabled"], selection: viewModel.showCanWallJumpIcon ? 1 : 0, setting: $viewModel.showCanWallJumpIcon)
            }
        }
        .frame(alignment: .center)
        #endif
    }
}

#if os(iOS)
struct MobileOptions: View {
    @Environment(ViewModel.self) private var viewModel
    let orientation: Orientation
    
    init(orientation: Orientation = .portrait) {
        self.orientation = orientation
    }

    var body: some View {
        if (orientation == .portrait) {
            VStack {
                Spacer()
                ResetTracker()
                Spacer()
                LockSettings()
                Spacer()
                ToggleCollectibleWallJump()
                Spacer()
                ToggleEye()
                Spacer()
                NetworkStatusAndToggle()
                Spacer()
            }
            .padding(0)
        } else {
            HStack {
                Spacer()
                ResetTracker()
                Spacer()
                LockSettings()
                Spacer()
                ToggleCollectibleWallJump()
                Spacer()
                ToggleEye()
                Spacer()
                NetworkStatusAndToggle()
                Spacer()
            }
            .padding(0)
        }
    }
}
#endif
