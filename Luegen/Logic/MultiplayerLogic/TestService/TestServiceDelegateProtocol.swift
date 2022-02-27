//
//  TestServiceDelegateProtocol.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 14.12.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol TestServiceDelegate {
    func connectedDevicesChanged(manager : TestService, connectedDevices: [String])
    func messageSent(manager : TestService, message: String)
}
