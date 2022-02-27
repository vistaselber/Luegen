//
//  DemoComputer.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 03.12.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class DemoComputer1 : AbstractComputer {
    
    override init(_ name: String, gamemaster: Gamemaster) {
        super.init(name, gamemaster: gamemaster)
    }
    override init(_ name: String){
        super.init(name)
    }
    
    override func setMoveCards() {
        if super.cards.count > 1{
            for i in 0..<super.cards.count-1{
                super.moveCards.append(super.cards[i].id)
            }
            
        }
        else if super.cards.count > 0 {
            super.moveCards.append(super.cards[0].id)
        }
    }
    
    //Cardtype der letzten Karte im Demoszenario wählen :)
    override func setCardIndexForMoveCardType(cardIndex: Int) -> Int {
        return super.cards.count-1
    }
    
    override func getTurn(_ previousUserCardsCount: Int) -> Int {
        //wenn keine Karten in der Mitte legen kann nur gelogen werden
        if gamemaster.carddeck.cards.count == 0 { return 0 }
        //wenn nur noch ein Gegner vorhanden ist, und dieser keine Karten mehr hat
        //macht nur noch aufdecken Sinn!
        if gamemaster.users.count == 1 && previousUserCardsCount == 0 { return 1 }
        
        //im Zweifel immer lügen...
        return 0
    }
}
