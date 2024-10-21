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
                HStack(spacing: viewModel.rootHStackSpacing) {
                    Bosses()
                    ItemGrid()
                    GameOptions()
                }
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
                ToggleCollectibleWallJump(size: 15)
                ToggleZebesAwake(size: 15)
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

//#if os(macOS)
//struct SeedName: View {
//    @State var editing = false;
//    @Environment(ViewModel.self) private var viewModel
//
//        
//    var body: some View {
//        @Bindable var appSettings = appSettings
//        
//        if (appSettings.showSeedName) {
//            if (editing) {
//                TextField("set seed name", text: $appSettings.seedName)
//                    .background(.black)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .font(.custom("SuperMetroidSNES", size: 28))
//                    .frame(maxWidth: .infinity, alignment: .top)
//                    .onSubmit {
//                        AppSettings.defaults.set(appSettings.seedName, forKey: "seedName")
//                        $editing.wrappedValue.toggle()
//                    }
//            } else {
//                Text(appSettings.seedName)
//                    .background(.black)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .font(.custom("SuperMetroidSNES", size: 28))
//                    .frame(maxWidth: .infinity, alignment: .top)
//                    .onTapGesture {
//                        $editing.wrappedValue.toggle()
//                    }
//            }
//        }
//    }
//}
//#endif

struct BossLayout: View {
    let bosses: [Boss]
    let size: CGFloat
    
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
            BossLayout(bosses: viewModel.bosses, size: viewModel.bossSize)
        }
        .padding(0)
        #else
        if (g.size.width > g.size.height) {
            VStack {
                BossLayout(bosses: viewModel.bosses, size: viewModel.bossSize)
            }
            .padding(0)
        } else {
            HStack {
                BossLayout(bosses: viewModel.bosses, size: viewModel.bossSize)
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

    func isItemActive(item: Item, viewModel: ViewModel) -> Binding<Bool> {
        @Bindable var viewModel = viewModel

        switch(item.key) {
            case "walljump":
                return $viewModel.collectibleWallJump
            case "zebesawake":
                return $viewModel.zebesAwake
            default:
                return .constant(true)
        }
    }

    var body: some View {
        #if os(iOS)
//        Spacer()
        #endif
        ForEach(row, id: \.id) { item in
            ItemButton(item: item, size: size, isActive: isItemActive(item: item, viewModel: viewModel))
            #if os(iOS)
//            Spacer()
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
        VStack(spacing: viewModel.itemGridVerticalSpacing) {
            ForEach(viewModel.items, id: \.self) { row in
                HStack(spacing: viewModel.itemGridHorizontalSpacing) {
                    ItemRows(row: row, size: viewModel.itemSize)
                }
            }
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
        #if os(macOS)
        VStack(spacing: viewModel.seedOptionVStackSpacing) {
            ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                if (seedOption.visible) {
                    OptionSelector(seedOption: seedOption)
                }
            }
        }
        #else
        VStack {
                ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                    if (seedOption.visible) {
                        OptionSelector(seedOption: seedOption)
                    }
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
                ToggleCollectibleWallJump()
                Spacer()
                ToggleZebesAwake()
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
                ToggleCollectibleWallJump()
                Spacer()
                ToggleZebesAwake()
                Spacer()
                NetworkStatusAndToggle()
                Spacer()
            }
            .padding(0)
        }
    }
}
#endif
