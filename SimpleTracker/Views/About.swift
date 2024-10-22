#if os(macOS)
//
//  About.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/21/24.
//
//  Copyright (C) 2024 Warpixel
//

import SwiftUI

struct NameAndVersion: View {
    var body: some View {
        VStack {
            Text("\(appName) for Map Rando")
                .font(.title)
                .shadow(color: .black, radius: 0, x: 0, y: 3)
            Text("Version \(appVersion)")
                .font(.subheadline)
        }
    }
}


struct Paragraph: View {
    let text: String
    let colored: [String: Color]
    let links: [String: String]
    
    init(_ text: String, colored: [String: Color] = [:], links: [String: String] = [:]) {
        self.text = text
        self.colored = colored
        self.links = links
    }
    
    var textBody: AttributedString {
        var textBody = AttributedString(text)
        
        for (text, color) in colored {
            if let range = textBody.range(of: text) {
                textBody[range].foregroundColor = color
            }
        }
        
        for (text, url) in links {
            if let range = textBody.range(of: text) {
                textBody[range].link = URL(string: url)
                textBody[range].foregroundColor = Color(0x6865FF)
                textBody[range].underlineStyle = .single
            }
        }
        
        return textBody
    }
    
    var body: some View {
        Text(textBody)
            .lineLimit(nil)
            .font(.body)
            .shadow(color: .black, radius: 0, x: 0, y: 3)
            .buttonStyle(PlainButtonStyle())
    }
}

struct About: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(nsImage: NSApplication.shared.applicationIconImage)
            NameAndVersion()
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Paragraph("\(appName) is a Super Metroid item tracker for Map Rando based on chicdead26's Emotracker pack.", colored: ["Map Rando": .pink, "chicdead26": .pink], links: ["Emotracker": "https://emotracker.net"])
                    Paragraph("For those not familair with Map Rando, it is a Super Metroid randomizer written by Maddo with specific features that make it, in my opinion, the best Super Metroid Randomizer.", colored: ["Map Rando": .pink, "Maddo": .pink], links: ["Map Rando": "https://maprando.com"])
                    Paragraph("The purpose of SimpleTracker is to provide a means of keeping track of the state of a certain game outside of the game itself, either just for your own easy reference, or for use in an OBS window source while streaming.", colored: ["window source": .pink])
                    Paragraph("There is nothing like Emotracker for Mac and I wanted to create a simple tracker to use while playing/streaming Map Rando that made sense.", colored: ["Emotracker": .pink])
                }
            }
            Spacer()
            Text("© 2024 fiftyshadesofurban and Warpixel")
                .font(.footnote)
                
        }
        .padding(20)
    }
}
#endif
