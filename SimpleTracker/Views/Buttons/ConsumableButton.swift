////
////  ConsumableBUtton.swift
////  SimpleTracker
////
////  Created by Alex Quintana on 10/7/24.
////
//
//import SwiftUI
//
//struct ConsumableButton: View {
//    var iconName: String
//    @State var collected: Int
//    @State var appState = ViewModel()
//    
//    init(iconName: String, collected: Int, appState: ViewModel = ViewModel()) {
//        self.iconName = iconName
//        self.collected = collected
//        self.appState = appState
//    }
//    
//    init(_ name: String) {
//        self.iconName = name
//        self.collected = 0
//        self.appState = ViewModel()
//    }
//    
//    
//    private func getNumItems() -> String {
//        if ["etank", "reservetank"].contains(iconName) {
//            return String(collected)
//        } else {
//            return String(collected*5)
//        }
//    }
//    
//    var body: some View {
//        ZStack(alignment: .bottomTrailing) {
//            Image(iconName)
//                .resizable()
//                .frame(width: 60, height: 60)
//                .gesture(
//                    TapGesture()
//                        .onEnded {
//                            if collected < maxPacks[iconName]! {
//                                collected += 1
//                                UserDefaults.standard.set(collected, forKey: iconName)
//                            }
//                        }
//                )
//                .gesture(
//                    LongPressGesture()
//                        .onEnded { _ in
//                            if collected > 0 {
//                                collected -= 1
//                                UserDefaults.standard.set(collected, forKey: iconName)
//                            }
//                        }
//                )
//                .modifier(Appearance(type: .item, isActive: collected > 0))
//            if (collected > 0) {
//                ItemCount(count: getNumItems())
//                    .frame(alignment: .bottomTrailing)
//            }
//        }
//            .frame(width: 60, height: 60)
//    }
//}