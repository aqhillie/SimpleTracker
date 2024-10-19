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
    @State private var title = "Crazytown"

    var body: some View {
        #if os(macOS)
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: viewModel.rootVStackSpacing) {
//                SeedName()
                HStack(spacing: viewModel.rootHStackSpacing) {
                    Bosses()
                    ItemGrid()
                    GameOptions()
                }
            }
        }
        .padding(0)
        .navigationTitle("\(title) - SimpleTracker")
        #else
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                if (geometry.size.width > geometry.size.height) {
                    VStack {
                        HStack {
                            Spacer()
                            Bosses(geometry: geometry)
                            Spacer()
                            ItemGrid(geometry: geometry)
                            Spacer()
                            GameOptions(geometry: geometry)
                            Spacer()
                        }
                    }
                } else {
                    HStack {
                        VStack {
                            Spacer()
                            Bosses(geometry: geometry)
                            Spacer()
                            ItemGrid(geometry: geometry)
                            Spacer()
                            GameOptions(geometry: geometry)
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
    let geometry: GeometryProxy
    #endif
        
    var body: some View {
        #if os(macOS)
        VStack(spacing: viewModel.bossVerticalSpacing) {
            BossLayout(bosses: viewModel.bosses, size: viewModel.bossSize)
        }
        .padding(0)
        #else
        if (geometry.size.width > geometry.size.height) {
            VStack {
                BossLayout(bosses: viewModel.bosses, size: geometry.size.height * 0.18)
            }
            .padding(0)
        } else {
            HStack {
                BossLayout(bosses: viewModel.bosses, size: geometry.size.width * 0.18)
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
        Spacer()
        #endif
        ForEach(row, id: \.id) { item in
            ItemButton(item: item, size: size, isActive: isItemActive(item: item, viewModel: viewModel))
            #if os(iOS)
            Spacer()
            #endif
        }
    }
}

struct ItemGrid: View {
    @Environment(ViewModel.self) private var viewModel
    #if os(iOS)
    let geometry: GeometryProxy
    
    let fullSize: CGFloat
    
    init(geometry: GeometryProxy) {
        self.geometry = geometry
        self.fullSize = (geometry.size.width > geometry.size.height) ? geometry.size.height : geometry.size.width
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
                    ItemRows(row: row, size: fullSize * 0.15)
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
    let geometry: GeometryProxy
    #endif
    
    var body: some View {
        HStack {
            VStack(spacing: viewModel.seedOptionVStackSpacing) {
                ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                    if (seedOption.visible) {
                        OptionSelector(seedOption: seedOption)
                    }
                }
            }
            #if os(iOS)
            if geometry.size.height > geometry.size.width {
                Spacer()
            }
            MobileOptions()
            if geometry.size.height > geometry.size.width {
                Spacer()
            }
            #endif
        }
        .background(Color.black)
    }
}

#if os(iOS)
struct MobileOptions: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        VStack {
            Spacer()
            ResetTracker()
            Spacer()
            ToggleCollectibleWallJump()
            Spacer()
            ToggleZebesAwake()
            Spacer()
        }
        .frame(alignment: .topLeading)
        .padding(0)
    }
}
#endif
