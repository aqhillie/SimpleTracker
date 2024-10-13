//
//  OptionSelector.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/7/24.
//

import SwiftUI

struct SeedOptionSelectorBody: View {
    let title: String
    let options: [String]
    let colors: [UInt]
    @Binding var selection: Int

    private func getColor(idx: Int, colors: [UInt]) -> UInt {
        if idx > colors.count - 1 {
            return colors[colors.count - 1]
        } else {
            return colors[idx]
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(title.uppercased())
                .background(.black)
                .foregroundColor(.white)
                .font(.custom("Apple Symbols", size: 18))
            Text(options[selection].uppercased())
                .frame(width: 320, alignment: .center)
                .background(.black)
                .foregroundColor(Color(getColor(idx: selection, colors: colors)))
                .font(.custom("Super Metroid (SNES)", size: 28))
        }
            .gesture(
                TapGesture()
                    .onEnded {
                        $selection.wrappedValue = (selection + 1) % options.count
                        AppSettings.defaults.set(selection, forKey: title.lowercased())
                    }
            )
    }
}

struct SeedObjectiveSelector: View {
    let title: String = "Objectives"
    let options: [String] = ["None", "Bosses", "Minibosses", "Metroids", "Chozos", "Pirates", "Random"]
    let colors: [UInt] = [0x808080]
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        @Bindable var appSettings = appSettings

        SeedOptionSelectorBody(title: title, options: options, colors: colors, selection: $appSettings.objective)
    }
}

struct SeedDifficultySelector: View {
    let title: String = "Difficulty"
    let options: [String] = ["Basic", "Medium", "Hard", "Very Hard", "Expert", "Extreme", "Insane"]
    let colors: [UInt] = [0x066815, 0xCBCA02, 0xC20003, 0x5B0012, 0x0766C0, 0x0400C3, 0xC706C9]
    @Environment(AppSettings.self) private var appSettings
    
    var body: some View {
        @Bindable var appSettings = appSettings

        SeedOptionSelectorBody(title: title, options: options, colors: colors, selection: $appSettings.difficulty)
    }
}

struct SeedItemProgressionSelector: View {
    let title: String = "Item Progression"
    let options: [String] = ["Normal", "Tricky", "Challenge", "Desolate"]
    let colors: [UInt] = [0x066815, 0xCBCA02, 0xC20003, 0xC706C9]
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        @Bindable var appSettings = appSettings

        SeedOptionSelectorBody(title: title, options: options, colors: colors, selection: $appSettings.itemProgression)
    }
}

struct SeedQualityOfLifeSelector: View {
    let title: String = "Quality of Life"
    let options: [String] = ["Off", "Low", "Default", "Max"]
    let colors: [UInt] = [0x5B0012, 0xC20003, 0xCBCA02, 0x066815]
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        @Bindable var appSettings = appSettings

        SeedOptionSelectorBody(title: title, options: options, colors: colors, selection: $appSettings.qualityOfLife)
    }
}

struct SeedMapLayoutSelector: View {
    let title: String = "Map Layout"
    let options: [String] = ["Vanilla", "Tame", "Wild"]
    let colors: [UInt] = [0x066815, 0xCBCA02, 0xC20003]
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        @Bindable var appSettings = appSettings

        SeedOptionSelectorBody(title: title, options: options, colors: colors, selection: $appSettings.mapLayout)
    }
}
