//
//  CardDeck.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 05.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class CardDeck : CardHolder{
    
    override init(){
        super.init()
        
        self.buildCardDeck()
        //self.printCardDeckSize() //for testing issues
        //self.printCardDeck() //for testing issues
        //self.printCardDeckSorted() //for testing issues
    }
    
    func getRandomNumber() -> Int {
        var randomNumber = 0
        var randomNumberExist: Bool = false
        
        repeat{
            randomNumberExist = false
            randomNumber = Int(arc4random_uniform(32))
            for c in self.cards{
                if c.sort == randomNumber{
                    randomNumberExist = true
                    break
                }
            }
        }while randomNumberExist == true
        
        return randomNumber
    }
    
    func giveCardsToUsers(users: [User]) { //-> [MoveLieEvent]{
        //print("CardDeck: giveCardToUsers Start")
        var userid = 0
        var cardid = 0
        var lastCard: Bool = false
        //var moveLieEvents: [MoveLieEvent] = []
        //var moveLieEvent: MoveLieEvent = MoveLieEvent()
        var userCardsCnt: Int = 0
        
        if users.count == 0{ return } // moveLieEvents}

        while cards.count > 0{
            cardid = Int.random(in: 0..<cards.count)
            //print("[CardDeck.giveCardsToUser]: Anzahl Karten = \(cards.count), vergebene Karde: \(cardid)")
            if(cards.count < 2){
                lastCard = true
            }
            
            //moveLieEvent = users[userid].getCard(card: cards[cardid], lastCard)
            users[userid].getCard(card: cards[cardid], lastCard)
            userCardsCnt += 1
            
            /*if !moveLieEvent.cards.isEmpty {
                moveLieEvents.append(moveLieEvent)
            }*/

            if userid == users.count - 1{ userid = 0 }
            else{ userid += 1 }
            
            if cardid < cards.count{
                cards.remove(at: cardid)
            }
            else{
                print("[CardDeck.giveCardsToUser]: soll eine Karte aus CardDeck entfernen, die gar nicht mehr da ist...")
            }
        }
        //print("[CardDeck.giveCardsToUser]: Spielkarten=\(self.cards.count), Spielerkarten=\(userCardsCnt)")
        //print("CardDeck: giveCardToUsers Ende")
        //return moveLieEvents
    }
    
    func resetCardDeck(){
        cards.removeAll()
        self.buildCardDeck()
    }
    
    private func buildCardDeck(){
        var cardcolor: CardColor
        var cardtype: CardType
        for cc in CardColor.colors{
            for ct in CardType.types{
                
                cardcolor = CardColor(color: cc[0] as! String)
                cardtype = CardType(cardtype: ct[0] as! String)
                self.cards.append(Card(cardcolor, cardtype, getRandomNumber()))
            }
        }
    }
    
    func append(card: Card){
        //print("CardDeck: bekomme Karte \(card.name)")
        cards.append(card)
    }

}
