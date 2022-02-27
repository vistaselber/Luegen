//
//  YourTurnProtocol.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 20.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

protocol YourTurn {
    func onYourTurn(yourTurn: YourTurnEvent)
}
