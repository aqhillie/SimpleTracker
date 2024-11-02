//
//  PeerConnection.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/19/24.
//
//  This file contains everything required to control the macOS app from the iPhone app.
//
//  Copyright (C) 2024 Warpixel
//

//import Foundation
//import CommonCrypto
import MultipeerConnectivity

@Observable
class PeerConnection: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    private let peerID: MCPeerID
    private var mcSession: MCSession!
    private var mcAdvertiser: MCNearbyServiceAdvertiser!
    private var mcBrowser: MCNearbyServiceBrowser!
        
    var viewModel: ViewModel
    var timerViewModel: TimerViewModel
    
    var hasConnectedPeers: Bool = false
    
    init(viewModel: ViewModel, timerViewModel: TimerViewModel) {
        self.viewModel = viewModel
        self.timerViewModel = timerViewModel
        
        #if os(iOS)
        let deviceName = UIDevice.current.name
        #elseif os(macOS)
        let deviceName = Host.current().localizedName ?? "Some Mac"
        #endif
        
        self.peerID = MCPeerID(displayName: deviceName)

        super.init()
        
        self.mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        self.mcSession.delegate = self
    }
        
    func setupAdvertiser() {
        mcAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "smmr-tracker")
        mcAdvertiser.delegate = self
        mcAdvertiser.startAdvertisingPeer()
    }
    
    func setupBrowser() {
        mcBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "smmr-tracker")
        mcBrowser.delegate = self
        mcBrowser.startBrowsingForPeers()
    }

    func disconnectPeer() {
        mcSession.disconnect()
    }
    
    func startAdvertisingPeer() {
        mcAdvertiser.startAdvertisingPeer()
    }

    func startBrowsingForPeers() {
        mcBrowser.startBrowsingForPeers()
    }

    func stopAdvertisingPeer() {
        mcAdvertiser.stopAdvertisingPeer()
    }

    func stopBrowsingForPeers() {
        mcBrowser.stopBrowsingForPeers()
    }
    
    func sendMessage(_ message: [String: Any]) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: message, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            if mcSession.connectedPeers.isEmpty {
                debug("No connected peers. Message not sent: \(jsonString)")
                return
            }

            if let messageData = jsonString.data(using: .utf8) {
                do {
                    try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
                    debug("Message sent: \(jsonString)")
                } catch {
                    debug("Error sending message: \(error)")
                }
            }
        } else {
            debug("Error converting message to JSON")
        }
    }
    
    #if os(iOS)
    func syncToDesktop() {
        // sync settings to desktop
        let seedData = SeedData.create(from: self.viewModel)
        let stringifiedSeedData = seedData.toJSON()
        
        if let stringifiedSeedData {
            let message = [
                "type": "cmd",
                "key": "incomingSeedFileData",
                "value": stringifiedSeedData
            ] as [String : Any]
            sendMessage(message)
        }
    }
    #endif
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        debug("in didReceive")
        do {
            // Convert the received data into a dictionary
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Now you can access your data as needed
                if let type = json["type"] as? String, let key = json["key"] as? String, let value = json["value"] {
                    debug("Received message: type = \(type) key = \(key), value = \(value)")

                    switch(type) {
                    case "boss":
                        DispatchQueue.main.async {
                            self.viewModel.updateBoss(from: json)
                            let seedData = SeedData.create(from: self.viewModel)
                            seedData.save()
                        }
                    case "item":
                        DispatchQueue.main.async {
                            self.viewModel.updateItem(from: json)
                            let seedData = SeedData.create(from: self.viewModel)
                            seedData.save()
                        }
                    case "cmd":
                        switch(key) {
                            #if os(macOS)
                            case "toggleTimer":
                                DispatchQueue.main.async {
                                    if self.timerViewModel.isRunning {
                                        self.timerViewModel.stopTimer()
                                    } else {
                                        self.timerViewModel.startTimer()
                                    }
                                }
                            case "resetTimer":
                                DispatchQueue.main.async {
                                    if self.timerViewModel.isRunning {
                                        self.timerViewModel.stopTimer()
                                    }
                                    self.timerViewModel.resetTimer()
                                }
                            case "timerStatusRequest":
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    let message = [
                                        "type": "cmd",
                                        "key": "timerVisibility",
                                        "value": self.timerViewModel.isVisible
                                    ]
                                    self.sendMessage(message)
                                }
                            #endif
                            #if os(iOS)
                            case "timerVisibility":
                                DispatchQueue.main.async {
                                    self.timerViewModel.isVisible = value as! Bool
                                }
                            case "timerRunning":
                                DispatchQueue.main.async {
                                    self.timerViewModel.isRunning = value as! Bool
                                }
                            #endif
                            case "incomingSeedFileData":
                                DispatchQueue.main.async {
                                    if let seedData = (value as! String).toSeedData() {
                                        self.viewModel.resetBosses()
                                        self.viewModel.resetItems()

                                        for key in seedData.defeatedBosses {
                                            self.viewModel.bosses[safe: key.toBossKey()]._isDead = true
                                        }
                                        
                                        for (key, count) in seedData.collectedItems {
                                            self.viewModel.items[safe: key.toItemKey()].collected = count
                                        }

                                        guard let objective = seedData.settings["objective"],
                                              let difficulty = seedData.settings["difficulty"],
                                              let itemProgression = seedData.settings["itemProgression"],
                                              let qualityOfLife = seedData.settings["qualityOfLife"],
                                              let mapLayout = seedData.settings["mapLayout"],
                                              let doors = seedData.settings["doors"],
                                              let startLocation = seedData.settings["startLocation"],
                                              let collectibleWallJump: Bool = seedData.settings["collectibleWallJump"] == 1 ? true: false else {
                                            debug("Guard on incoming seed file settings dictionary failure.")
                                            return
                                        }
                                        
                                        self.viewModel.objective = objective
                                        self.viewModel.difficulty = difficulty
                                        self.viewModel.itemProgression = itemProgression
                                        self.viewModel.qualityOfLife = qualityOfLife
                                        self.viewModel.mapLayout = mapLayout
                                        self.viewModel.doors = doors
                                        self.viewModel.startLocation = startLocation
                                        self.viewModel.collectibleWallJump = collectibleWallJump
                                        
                                        let seedData = SeedData.create(from: self.viewModel)
                                        seedData.save()
                                    } else {
                                        debug("Failed to read incoming seed file data.")
                                    }
                                }
                            case "seedFileRequest":
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    if (SeedData.checkSeed()) {
                                        guard let seedData = SeedData.createFromFile(), let stringifiedSeedFile = seedData.toJSON() else {
                                                debug("Failed to get seed data.")
                                            return
                                        }
                                        
                                        let message = [
                                            "type": "cmd",
                                            "key": "incomingSeedFileData",
                                            "value": stringifiedSeedFile
                                        ]
                                        self.sendMessage(message)
                                    } else {
                                        debug("Peer requested seed file but none exists. :(")
                                    }
                                }
                            case "broadcastMode":
                                DispatchQueue.main.async {
                                    self.viewModel.broadcastMode = value as! Bool
                                }
                            case "resetTracker":
                                DispatchQueue.main.async {
                                    self.viewModel.resetBosses()
                                    self.viewModel.resetItems()
                                    
                                    let seedData = SeedData.create(from: self.viewModel)
                                    seedData.save()
                                }
                            case "objective":
                                DispatchQueue.main.async {
                                    self.viewModel.objective = value as! Int
                                    
                                    let seedData = SeedData.create(from: self.viewModel)
                                    seedData.save()
                                }
                            case "difficulty":
                                DispatchQueue.main.async {
                                    self.viewModel.difficulty = value as! Int
                                    
                                    let seedData = SeedData.create(from: self.viewModel)
                                    seedData.save()
                                }
                            case "itemProgression":
                                DispatchQueue.main.async {
                                    self.viewModel.itemProgression = value as! Int
                                    
                                    let seedData = SeedData.create(from: self.viewModel)
                                    seedData.save()
                                }
                            case "qualityOfLife":
                                DispatchQueue.main.async {
                                    self.viewModel.qualityOfLife = value as! Int
                                    
                                    let seedData = SeedData.create(from: self.viewModel)
                                    seedData.save()
                                }
                            case "mapLayout":
                                DispatchQueue.main.async {
                                    self.viewModel.mapLayout = value as! Int
                                }
                            case "doors":
                                DispatchQueue.main.async {
                                    self.viewModel.doors = value as! Int
                                    
                                    let seedData = SeedData.create(from: self.viewModel)
                                    seedData.save()
                                }
                            case "startLocation":
                                DispatchQueue.main.async {
                                    self.viewModel.startLocation = value as! Int
                                    
                                    let seedData = SeedData.create(from: self.viewModel)
                                    seedData.save()
                                }
                            case "collectibleWallJump":
                                DispatchQueue.main.async {
                                    self.viewModel.collectibleWallJump = value as! Bool
                                    
                                    let seedData = SeedData.create(from: self.viewModel)
                                    seedData.save()
                                }
                            case "collectibleWallJumpMode":
                                DispatchQueue.main.async {
                                    self.viewModel.collectibleWallJumpMode = value as! Int
                                }
                            default:
                                return
                        }
                    default:
                        return
                    }
                }
            }
        } catch {
            debug("Error decoding received data: \(error)")
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            debug("Connected to peer: \(peerID.displayName)")
            #if os(macOS)
            if (!SeedData.checkSeed()) {
                let message = [
                    "type": "cmd",
                    "key": "seedFileRequest",
                    "value": ""
                ]
                self.sendMessage(message)
            }
            #endif
            #if os(iOS)
            if (!SeedData.checkSeed()) {
                let message = [
                    "type": "cmd",
                    "key": "seedFileRequest",
                    "value": ""
                ]
                self.sendMessage(message)
            } else {
                syncToDesktop()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let message = [
                    "type": "cmd",
                    "key": "timerStatusRequest",
                    "value": ""
                ]
                self.sendMessage(message)
            }
            #endif
        case .connecting:
            debug("Connecting to peer: \(peerID.displayName)")
        case .notConnected:
            debug("Disconnected from peer: \(peerID.displayName)")
            debug(hasConnectedPeers)
        @unknown default:
            fatalError("Unknown state for peer: \(peerID.displayName)")
        }
        hasConnectedPeers = !mcSession.connectedPeers.isEmpty
    }

    // These delegate methods are required but not needed for basic functionality
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Accept the invitation automatically
        invitationHandler(true, mcSession)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        debug("Failed to start advertising: \(error.localizedDescription)")
    }
    
    // Required methods for MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        debug("Found peer: \(peerID.displayName)")
        // Invite the peer to join the session
        mcBrowser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        debug("Lost peer: \(peerID.displayName)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        debug("Failed to start browsing for peers: \(error.localizedDescription)")
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
}

