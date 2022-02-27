//
//  User.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 05.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class RandomComputer : User {
/*
    var turnString: String = ""
    
    override func onYourTurn(name: String) {
        var gamemaster = Gamemaster.getInstance()
        var turn : Int = Int.random(in: 0..<2)
        var moveLie: MoveLie
        var moveCards: [UUID] = []
        var moveCardsCount : Int = Int.random(in: 0..<3)
        var moveCardIndex : Int = 0

        if name != super.name { return }
        
        //wenn keine Karten in der Mitte legen kann nur gelogen werden
        print ("\(super.name): Anzahl der Karten im Kartendeck =  \(gamemaster.carddeck.cards.count)")
        if gamemaster.carddeck.cards.count == 0 { turn = 0 }
        
        switch turn{
        case 0: // lie
            while moveCardsCount > 0{
                moveCardIndex = Int.random(in: 0..<super.cards.count)
                moveCards.append(super.cards[moveCardIndex].id)
                moveCardsCount -= 1
            }
            if MoveLie.moveCardType == "" {  }
            //moveLie = MoveLie(moveCards: moveCards, moveCardType: MoveLie.moveCardType)
            super.lie(moveLie: moveLie)
            self.turnString = "lügt und legt: \(moveCards.count) Karten als \(MoveLie.moveCardType)"
        case 1: // dont lie
            super.dontBelieve(dontBelieve: true)
            self.turnString = "glaubt dem vorherigen Spieler nicht."
        default:
            break
        }
        
        //print("\(super.name): \(self.turnString)")
    }
*/  
}
