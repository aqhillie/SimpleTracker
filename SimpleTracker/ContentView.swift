//
//  ContentView.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 25) {
//                SeedName()
                HStack(spacing: 20) {
//                    Bosses()
//                    ItemGrid()
//                    GameOptions()
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .padding(0)
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

//struct Bosses: View {
//    var body: some View {
//        VStack(spacing: 30) {
//            BossRidley()
//            BossPhantoon()
//            BossKraid()
//            BossDraygon()
//        }
//        .padding(0)
//    }
//}
//
//struct ItemGrid: View {    
//    var body: some View {
//        VStack(spacing: verticalSpacing) {
//            HStack(spacing: horizontalSpacing) {
//            }
//        }
//        .padding(0)
//    }
//}
//
//struct GameOptions: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            SeedObjectiveSelector()
//            SeedDifficultySelector()
//            SeedItemProgressionSelector()
//            SeedQualityOfLifeSelector()
//            SeedMapLayoutSelector()
//        }
//        .background(Color.black)
//    }
//}
//
