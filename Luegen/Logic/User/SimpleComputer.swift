//
//  User.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 05.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class SimpleComputer : AbstractComputer {
    
    override init(_ name: String){
        super.init(name)
    }

    override func onYourTurn(yourTurn: YourTurnEvent) {
        super.onYourTurn(yourTurn: yourTurn)
        //print("\(super.name): \(self.turnString)")
    }
    
    override func setMoveCards() {
        //SimpleComputer legt immer nur eine Karte!
        if super.cards.count > 0 { super.moveCards.append(super.cards[0].id) }
    }

}
