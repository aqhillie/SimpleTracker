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
    private var  mcBrowser: MCNearbyServiceBrowser!
    
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
    
//    private func generateHash() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let hashInput = "SimpleTracker for Map Rando \(dateFormatter.string(from: Date()))"
//        let data = Data(hashInput.utf8)
//        
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
//        
//        data.withUnsafeBytes {
//            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), digest)
//        }
//        
//        return digest.map { String(format: "%02hhx", $0) }.joined()
//    }
    
    func setupAdvertiser() {
        mcAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "trackersync")
        mcAdvertiser.delegate = self
        mcAdvertiser.startAdvertisingPeer()
    }
    
    func setupBrowser() {
        mcBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "trackersync")
    }
    
    func sendMessage(_ message: String) {
//        let hash = generateHash()

//        if let messageData = "\(message)|\(hash)".data(using: .utf8) {

        
        if mcSession.connectedPeers.isEmpty {
            print("No connected peers. Message not sent: \(message)")
            return
        }
        
        if let messageData = message.data(using: .utf8) {
            do {
                try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
                print("Message sent: \(message)")
            } catch {
                print("Error sending message: \(error)")
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
//            let messageParts = message.split(separator: "|")
//            let hash = message[1]
//            if hash == generateHash() {
//                print("Received message: \(message[0])")
            print("Received message: \(message)")
//            } else {
//                print("Invalid hash received.")
//                print("Message rejected: \(message[0])")
//            }
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected to peer: \(peerID.displayName)")
        case .connecting:
            print("Connecting to peer: \(peerID.displayName)")
        case .notConnected:
            print("Disconnected from peer: \(peerID.displayName)")
        @unknown default:
            fatalError("Unknown state for peer: \(peerID.displayName)")
        }
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

