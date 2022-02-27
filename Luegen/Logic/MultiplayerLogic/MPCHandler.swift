//
//  MPCHandler.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 04.12.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

import MultipeerConnectivity
//https://www.youtube.com/watch?v=JwqsbsyN3LA
//https://www.hackingwithswift.com/example-code/networking/how-to-create-a-peer-to-peer-network-using-the-multipeer-connectivity-framework

class MPCHandler: NSObject , MCSessionDelegate , MCBrowserViewControllerDelegate{
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    var serviceType: String = "MyLuegenGame"
    
    func setupMPCHandler(displayName: String){
        self.setupPeerWithDisplayName(displayName: displayName)
        self.setupSession()
        self.setupBrowser()
    }
    
    func setupPeerWithDisplayName(displayName: String){
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        session = MCSession(peer: self.peerID)
    }
    
    func setupSession(peer: MCPeerID){
        session = MCSession(peer: peer)
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: self.serviceType, session: self.session)
    }
    
    //star hosting!
    func advertiseSelf(advertise: Bool){
        if(advertise){
            advertiser = MCAdvertiserAssistant(serviceType: self.serviceType, discoveryInfo: nil, session: session)
            self.advertiser!.start()
        }
        else{
            self.advertiser!.stop()
            self.advertiser = nil
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID":peerID, "state":state.rawValue] as [String : Any]
        
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
        /*dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NotificationCenter.default.post(name: "MPC_DidChangeStateNotification", object: nil, userInfo: userInfo)
        })*/
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data":data, "peerID":peerID] as [String : Any]
        /*dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NotificationCenter.default.post(name: "MPC_DidReceiveDataNotification", object: nil, userInfo: userInfo)*/
        if let image = UIImage(data: data) {
            DispatchQueue.main.async { [unowned self] in
                // do something with the image
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        return
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        return
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        return
    }
    
    func sendImage(img: UIImage) {
        if self.session.connectedPeers.count > 0 {
            if let imageData = img.pngData() {
                do {
                    try self.session.send(imageData, toPeers: self.session.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    //present(ac, animated: true)
                }
            }
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController){
        print("browserViewControllerDidFinish()")
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("browserViewControllerWasCancelled()")
    }
    
    func startHosting(action: UIAlertAction!) {
        //self. = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        //mcAdvertiserAssistant.start()
        self.setupMPCHandler(displayName: "Test...")
        self.advertiseSelf(advertise: true)
    }
    
    func joinSession(action: UIAlertAction!) {
        //let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        //mcBrowser.delegate = self
        //present(mcBrowser, animated: true)
        self.setupMPCHandler(displayName: "Test...")
        self.browser.delegate = self
    }


}
