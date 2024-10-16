//
//  ContentView.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var title = "Crazytown"

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(spacing: 25) {
                    //                SeedName()
                    HStack(spacing: 20) {
                        Bosses()
                        ItemGrid()
                        SeedOptions()
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            .padding(0)
            .navigationTitle("\(title) - SimpleTracker")
            .toolbarRole(.editor)
        }
    }
}

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
//                    .font(.custom("Super Metroid (SNES)", size: 28))
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
//                    .font(.custom("Super Metroid (SNES)", size: 28))
//                    .frame(maxWidth: .infinity, alignment: .top)
//                    .onTapGesture {
//                        $editing.wrappedValue.toggle()
//                    }
//            }
//        }
//    }
//}

struct Bosses: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        VStack(spacing: 30) {
            ForEach(viewModel.bosses, id: \.id) { boss in
                BossButton(for: boss)
            }
        }
        .padding(0)
    }
}

//struct ItemOrElse: View {
//    @Environment(ViewModel.self) private var viewModel
//    let item: Item?
//    
//    var body: some View {
//    }
//}

struct ItemGrid: View {
    @Environment(ViewModel.self) private var viewModel
    
    func isItemActive(item: Item, viewModel: ViewModel) -> Binding<Bool> {
        @Bindable var viewModel = viewModel

        switch(item.key) {
            case "walljump":
                return $viewModel.collectibleWallJump
            default:
            return .constant(true)
        }
    }
    
    var body: some View {
        VStack(spacing: viewModel.itemGridVerticalSpacing) {
            ForEach(viewModel.items, id: \.self) { row in
                HStack(spacing: viewModel.itemGridHorizontalSpacing) {
                    ForEach(row, id: \.id) { item in
                        ItemButton(item: item, isActive: isItemActive(item: item, viewModel: viewModel))
                    }
                }
            }
        }
        .padding(0)
    }
}


struct SeedOptions: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(viewModel.seedOptions, id: \.key) { seedOption in
                if (seedOption.visible) {
                    OptionSelector(seedOption: seedOption)
                }
            }
        }
        .background(Color.black)
    }
}

