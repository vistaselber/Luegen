//
//  Message.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 16.12.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

struct Message: Codable {
    let body: String
}

extension Device {
    func send(text: String) throws {
        let message = Message(body: text)
        let payload = try JSONEncoder().encode(message)
        try self.session?.send(payload, toPeers: [self.peerID], with: .reliable)
    }
}
