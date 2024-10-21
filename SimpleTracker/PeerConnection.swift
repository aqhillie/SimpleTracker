//
//  RemoteControl.swift
//  SimpleTracker
//
//  Created by Alex Quintana on 10/19/24.
//
//  This file contains everything required to control the macOS app from the iPhone app.
//
//  Copyright (C) 2024 Warpixel
//

import Foundation
import CommonCrypto
import MultipeerConnectivity

@Observable
class PeerConnection: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    private let peerID: MCPeerID
    private var mcSession: MCSession!
    private var mcAdvertiser: MCNearbyServiceAdvertiser!
    private var mcBrowser: MCNearbyServiceBrowser!
        
    var viewModel: ViewModel?
    var hasConnectedPeers: Bool = false
    
    override init() {
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
                print("No connected peers. Message not sent: \(jsonString)")
                return
            }

            if let messageData = jsonString.data(using: .utf8) {
                do {
                    try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
                    print("Message sent: \(jsonString)")
                } catch {
                    print("Error sending message: \(error)")
                }
            }
        } else {
            print("Error converting message to JSON")
        }
    }
    
    #if os(macOS)
    func sendSettings() {
        let message = [
            "type": "cmd",
            "key": "syncSettings",
            "value": [
                "showBosses": viewModel?.showBosses as Any,
                "collectibleWallJump": viewModel?.collectibleWallJump as Any,
                "zebesAwake": viewModel?.zebesAwake as Any,
                "objectives": viewModel?.seedOptions[0].selection as Any,
                "difficulty": viewModel?.seedOptions[1].selection as Any,
                "itemProgression": viewModel?.seedOptions[2].selection as Any,
                "qualityOfLife": viewModel?.seedOptions[3].selection as Any,
                "mapLayout": viewModel?.seedOptions[4].selection as Any
            ]
        ] as [String : Any]
        sendMessage(message)
    }
    #endif
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            // Convert the received data into a dictionary
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Now you can access your data as needed
                if let type = json["type"] as? String, let key = json["key"] as? String, let value = json["value"] {
                    print("Received message: type = \(type) key = \(key), value = \(value)")

                    switch(type) {
                    case "boss":
                        viewModel?.updateBoss(from: json)
                    case "item":
                        viewModel?.updateItem(from: json)
                    case "cmd":
                        switch(key) {
                            case "resetTracker":
                                viewModel?.resetBosses()
                                viewModel?.resetItems()
                            #if os(iOS)
//                            case "syncSettings":
//                                viewModel?.showBosses = value["showBosses"]
//                                viewModel?.collectibleWallJump = value["collectibleWallJump"]
//                                viewModel?.zebesAwake = value["zebesAwake"]
//                                viewModel?.seedOptions[0].selection = value["objectives"]
//                                viewModel?.seedOptions[1].selection = value["difficulty"]
//                                viewModel?.seedOptions[2].selection = value["itemProgression"]
//                                viewModel?.seedOptions[3].selection = value["qualityOfLife"]
//                                viewModel?.seedOptions[4].selection = value["mapLayout"]
                            #endif
                            default:
                                return
                            
                        }
                    default:
                        return
                    }
                }
            }
        } catch {
            print("Error decoding received data: \(error)")
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected to peer: \(peerID.displayName)")
            #if os(macOS)
            #endif
        case .connecting:
            print("Connecting to peer: \(peerID.displayName)")
        case .notConnected:
            print("Disconnected from peer: \(peerID.displayName)")
            print(hasConnectedPeers)
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
        print("Failed to start advertising: \(error.localizedDescription)")
    }
    
    // Required methods for MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found peer: \(peerID.displayName)")
        // Invite the peer to join the session
        mcBrowser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID.displayName)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start browsing for peers: \(error.localizedDescription)")
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
}

