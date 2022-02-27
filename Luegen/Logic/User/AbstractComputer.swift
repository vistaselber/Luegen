//
//  AbstractComputer.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 24.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class AbstractComputer: User{ //User{
    
    var gamemaster : Gamemaster
    var turn : Int
    var moveLie: MoveLieEvent
    var moveCards: [UUID]
    var moveCardType: String
    var turnString: String
    
    init(_ name: String, gamemaster: Gamemaster){
        self.gamemaster = gamemaster //Gamemaster.getInstance()
        turn = 0
        moveLie = MoveLieEvent()
        moveCards = []
        moveCardType = ""
        turnString = ""
        super.init(name)
    }
    override init(_ name: String){
        print("Initialisiere leeren Gamemaster, soll eigentlich nicht passieren")
        gamemaster = Gamemaster()//dummy: true //Gamemaster.getInstance()
        turn = 0
        moveLie = MoveLieEvent()
        moveCards = []
        moveCardType = ""
        turnString = ""
        super.init(name)
    }
    
    override func onYourTurn(yourTurn: YourTurnEvent) {

        if yourTurn.name != super.name { return }
        
        //wait()
        
        self.turn = self.getTurn(yourTurn.previousUserCardsCount)
        
        switch turn{
        case 0: // lie
            self.lie()
        case 1: // dont lie
            super.dontBelieve(dontBelieve: true)
        default:
            break
        }
    }
    
    func getTurn(_ previousUserCardsCount: Int) -> Int {
        //wenn keine Karten in der Mitte legen kann nur gelogen werden
        if gamemaster.carddeck.cards.count == 0 { return 0 }
        //wenn nur noch ein Gegner vorhanden ist, und dieser keine Karten mehr hat
        //macht nur noch aufdecken Sinn!
        if gamemaster.users.count == 1 && previousUserCardsCount == 0 { return 1 }
        
        return Int.random(in: 0..<2)
    }
    
    func lie(){
        
        self.setMoveCards()
        //print("AbstractComputer: MoveLie.moveCardType = \(MoveLie.moveCardType)")
        self.setMoveCardType()
        
        //moveLie = MoveLie(moveCards: moveCards, moveCardType: moveCardType)
        moveLie.setMoveCards(moveCards: moveCards)
        moveLie.setMoveCardType(moveCardType: moveCardType)
        
        //if super.NonEvent == true {
            super.lie(moveLie: moveLie)
        //}
        //else{
        //    super.lie(moveLie: moveLie)
        //}
    }
    
    func setMoveCards(){
        
    }
    func setMoveCardType(){
        if(MoveLieEvent.moveCardType != ""){ self.moveCardType = MoveLieEvent.moveCardType }
        else{
            for index in 0..<super.cards.count{
                setMyMoveCardType(cardIndex: self.setCardIndexForMoveCardType(cardIndex: index))
                if self.moveCardType != CardType.ass { break }
            }
        }
    }
    
    func setCardIndexForMoveCardType(cardIndex: Int) -> Int {
        return cardIndex
    }
    
    func setMyMoveCardType(cardIndex: Int){
        self.moveCardType = super.cards[cardIndex].cardtype.cardtype
    }
    
}
