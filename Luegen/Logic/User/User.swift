//
//  User.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 05.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class User : CardHolder, YourTurn {

    func onYourTurn(yourTurn: YourTurnEvent) {
        // no reaction on YourTurn from Gamemaster
        // User is manages by a person
        //print("User: Jetzt ist \(self.name) dran - das bin ich!")
    }
    
    
    @Published var name: String
    //Event
    let lie = Event<MoveLieEvent>()
    let dontBelieve = Event<Bool>()
    let fourOfAKind = Event<MoveLieEvent>()

    init(_ name: String){
        self.name = name
        super.init()
    }
    
    func getCard(card: Card, _ lastCard: Bool) { //}-> MoveLieEvent{
        //var fourOfAKind: Bool = false
        var moveLie: MoveLieEvent = MoveLieEvent()
        //print("User (\(self.name)):getCard()")
        self.cards.append(card)
        if lastCard == true {
            //moveLie = checkFourOfAKind()
            checkFourOfAKind()
        }
        //return moveLie
    }
    
    func checkFourOfAKind(){
        var cntCardTypes : [CardType]
        var moveLie: MoveLieEvent = MoveLieEvent()
        var cardIndex: Int = 9999
        var cardForCtRemains: Bool = false
        //var fourOfAKind: Bool = false
        
        moveLie.cards.removeAll() //aufräumen
        //print("User (\(self.name)): CheckFourOfAKind()")
        cntCardTypes = self.countCardsPerCardType()
        
        for indexCt in 0..<cntCardTypes.count{
            if(cntCardTypes[indexCt].cardtype == CardType.ass) { continue }
            
            if cntCardTypes[indexCt].value < 4 { continue }
            
            print("[User.checkFourOfAKind (\(self.name))]: Ich habe 4 \(cntCardTypes[indexCt].cardtype) und nehme diese aus dem Spiel")
            cardForCtRemains = true
            while(cardForCtRemains){
                cardIndex = self.findCardForCardType(cardtype: cntCardTypes[indexCt].cardtype, lastCardIndex: cardIndex)
                if cardIndex != 9999 {
                    moveLie.cards.append(self.cards[cardIndex])
                    //self.cards.remove(at: cardIndex)
                }
                else{
                    cardForCtRemains = false
                    cardIndex = 9999 //aufräumen
                }
            }
            //self.fourOfAKind = true
            //self.fourOfAKind.emit(data: moveLie)
            //self.removeCards(moveLie.cards)
        }
        //return fourOfAKind
        moveLie.userName = self.name
        self.removeCards(moveLie.cards)
        if !moveLie.cards.isEmpty{
            self.fourOfAKind.emit(data: moveLie)
        }
        //return moveLie
    }
    
    func removeCards(_ cards: [Card] ){
        var cardIndex: Int = 0
        for m in 0..<cards.count{
            cardIndex = self.findCard(cards[m])
            if cardIndex == 9999 { continue }
            super.cards.remove(at: cardIndex)
        }
    }
    func findCard(_ card: Card) -> Int {
        for i in 0..<super.cards.count{
            if super.cards[i].name == card.name {
                return i
            }
        }
        return 9999
    }
    
    func countCardsPerCardType() -> [CardType] {
        var cntCardType: CardType
        var cntCardTypes : [CardType] = []

        //initialisieren
        for ct in CardType.types{
            cntCardType = CardType(cardtype: ct[0] as! String)
            cntCardType.value = 0
            cntCardTypes.append(cntCardType)
        }
        //zählen
        for i in 0..<self.cards.count {
            for j in 0..<cntCardTypes.count {
                if self.cards[i].cardtype.cardtype == cntCardTypes[j].cardtype {
                    cntCardTypes[j].value += 1
                }
            }
        }
        return cntCardTypes
    }
    
    func findCardForCardType(cardtype: String, lastCardIndex: Int) -> Int{
        var lastCardIndex: Int = lastCardIndex
        if lastCardIndex == 9999 { lastCardIndex = 0 }
        else { lastCardIndex += 1}
        for index in lastCardIndex..<self.cards.count {
            if self.cards[index].cardtype.cardtype == cardtype {
                return index
            }
        }
        return 9999
    }
    
    func lie(moveLie: MoveLieEvent){
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
        
        self.lie.emit(data: moveLie)
    }
    
    func dontBelieve(dontBelieve: Bool){
        print("User: \(self.name): Ich glaube meinem vorherigen Spieler nicht...")
        self.dontBelieve.emit(data: dontBelieve)
    }
}
