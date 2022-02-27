//
//  NonEventUser.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 29.11.21.
//  Copyright © 2021 Jan Hummel. All rights reserved.
//

import Foundation

class NonEventUser : User {
    
    let NonEvent: Bool = true
    
    func lie(moveLie: MoveLieEvent) ->  MoveLieEvent{
        //print("User: \(self.name): Ich lüge jetzt")
        var cardIndex: Int = 0
        var findCardId: Bool = false
        
        for cardId in moveLie.moveCards {
            for index in 0..<self.cards.count {
                if self.cards[index].id == cardId {
                    findCardId = true
                    cardIndex = index
                    moveLie.cards.append(self.cards[index])
                    print("User: \(self.name) legt \(self.cards[index].name)")
                    break
                }
            }
            if findCardId { self.cards.remove(at: cardIndex) }
            findCardId = false
        }
        
        //self.lie.emit(data: moveLie)
        return moveLie
    }
    
    func dontBelieve(dontBelieve: Bool) -> Bool{
        print("User: \(self.name): Ich glaube meinem vorherigen Spieler nicht...")
        //self.dontBelieve.emit(data: dontBelieve)
        return dontBelieve
    }
}
