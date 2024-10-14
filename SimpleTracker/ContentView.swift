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
                SeedName()
                HStack(spacing: 20) {
                    bosses
                    ItemGrid()
                    GameOptions()
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .padding(0)
    }
}

struct SeedName: View {
    @State var editing = false;
    @Environment(AppSettings.self) private var appSettings

        
    var body: some View {
        @Bindable var appSettings = appSettings
        
        if (appSettings.showSeedName) {
            if (editing) {
                TextField("set seed name", text: $appSettings.seedName)
                    .frame(maxWidth: 400, alignment: .center)
                    .background(.black)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.custom("Super Metroid (SNES)", size: 28))
                    .frame(maxWidth: .infinity, alignment: .top)
                    .onSubmit {
                        AppSettings.defaults.set(appSettings.seedName, forKey: "seedName")
                        $editing.wrappedValue.toggle()
                    }
            } else {
                Text(appSettings.seedName)
                    .frame(maxWidth: 400, alignment: .center)
                    .background(.black)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.custom("Super Metroid (SNES)", size: 28))
                    .frame(maxWidth: .infinity, alignment: .top)
                    .onTapGesture {
                        $editing.wrappedValue.toggle()
                    }
            }
        }
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
    let horizontalSpacing: CGFloat = 12
    let verticalSpacing: CGFloat = 4
    
    var body: some View {
        VStack(spacing: verticalSpacing) {
            HStack(spacing: horizontalSpacing) {
                ChargeBeam()
                VariaSuit()
                MorphBall()
                HiJumpBoots()
                Missiles()
            }
            HStack(spacing: horizontalSpacing) {
                IceBeam()
                GravitySuit()
                MorphBallBomb()
                SpaceJump()
                SuperMissiles()
            }
            HStack(spacing: horizontalSpacing) {
                WaveBeam()
                EmptyCell()
                SpringBall()
                SpeedBooster()
                PowerBombs()
            }
            HStack(spacing: horizontalSpacing) {
                Spazer()
                GrappleBeam()
                ScrewAttack()
                WallJump()
                EnergyTanks()
            }
            HStack(spacing: horizontalSpacing) {
                PlasmaBeam()
                XRayScope()
                EmptyCell()
                EmptyCell()
                ReserveTanks()
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

