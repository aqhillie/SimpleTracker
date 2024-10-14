//
//  ContentView.swift
//  Simple Tracker
//
//  Created by Alex Quintana on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    @State var appSettings = AppSettings()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            HStack(spacing: 20) {
                bosses
                ItemGrid()
                GameOptions()
                    .environment(appSettings)
            }
        }
        .padding(0)
    }
}

private var bosses: some View {
    VStack(spacing: 30) {
        BossRidley()
        BossPhantoon()
        BossKraid()
        BossDraygon()
    }
    .padding(0)
}

struct ItemGrid: View {
    let itemMatrix = [
        [ChargeBeam.self, VariaSuit.self, MorphBall().self, HiJumpBoots.self, Missiles.self],
        [IceBeam.self, GravitySuit.self, MorphBallBomb.self, SpaceJump.self, SuperMissiles.self],
        [WaveBeam.self, EmptyCell.self, SpringBall.self, SpeedBooster.self, PowerBombs.self],
        [Spazer.self, GrappleBeam.self, ScrewAttack.self, EmptyCell.self, EnergyTanks.self],
        [PlasmaBeam.self, XRayScope.self, EmptyCell.self, EmptyCell.self, ReserveTanks.self]
    ]

    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<5) { row in
                HStack(spacing: 12) {
                    ForEach(0..<5) { col in
                        itemMatrix[row][col]
                    }
                }
            }
        }
        .padding(0)
    }
}

struct GameOptions: View {
    var body: some View {
        VStack(spacing: 20) {
            SeedObjectiveSelector()
            SeedDifficultySelector()
            SeedItemProgressionSelector()
            SeedQualityOfLifeSelector()
            SeedMapLayoutSelector()
        }
        .background(Color.black)
    }
}

