//
//  MultiplayerOverview.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 04.12.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI



struct MultiplayerOverview: View {
    
    @State var connectionsLabel: String
    @State var message: String
    
    var mpcManager: MPCManager = MPCManager()
    var devices: [Device] = []
    
    var mpcHandler: MPCHandler = MPCHandler()
    let testService = TestService()
    //var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("\(self.connectionsLabel)")
        
        /*Button(action: {
            self.testService.
        }){
            Text("Browse")
        }*/
        Button(action: {
            self.mpcManager.start()
        }) {
            Text("Verbinde")
        }
        VStack{
            ForEach(0..<self.devices.count, id: \.self) { index in
                Text("verbundenes Gerät: \(self.devices[index].name)")
            }
        }
        
        Button(action: {
            //self.mpcHandler.startHosting(action: <#T##UIAlertAction!#>)
            self.testService.delegate = self
            self.testService.sendMessage(message: "Hallo")
        }) {
            Text("Say Hallo")
        }
        Button(action: {
            //self.mpcHandler.startHosting(action: <#T##UIAlertAction!#>)
            self.testService.delegate = self
            self.testService.sendMessage(message: "Welt")
        }) {
            Text("Say World")
        }
        Text("Nachricht: \(message)")
        Text("meine PeerID: \(self.testService.getPeerId().displayName)")
        
    }
    
    /*//@IBAction
    func connectWithPlayer(sender:AnyObject){
        if self.appDelegate
    }*/
    
    /*mutating func reload(){
        self.devices = Array(MPCManager.instance.devices).sorted(by: { $0.name < $1.name })
    }*/
}

struct MultiplayerOverview_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerOverview(connectionsLabel: "Verbindungen", message: "Hallo")
    }
}

extension MultiplayerOverview : TestServiceDelegate {
    
    func connectedDevicesChanged(manager:TestService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel = "Connected devices: \(connectedDevices)"
        }
    }

    func messageSent(manager: TestService, message: String) {
        OperationQueue.main.addOperation {
            switch message {
            case "Hallo":
                self.message = "Jemand sagte '\(message)', ich ergänze: Welt"
            case "World":
                self.message = "Jemand sagte '\(message)', ich ergänze: Hallo \(message)"
            default:
                NSLog("%@", "Unknown color value received: \(message)")
            }
        }
    }
}
