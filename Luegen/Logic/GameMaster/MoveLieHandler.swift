//
//  MoveLieHandler.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 28.11.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class MoveLieHandler: AbstractGamemaster, MoveLieHandlerDelegate{
    
    func addListenerToUser(user: User, fourOfAKindAlreadySet: Bool) -> User {
        //TODO: wenn 1 User das Event fourOfAKind emitted, wird für alle User durch die Methode gelaufen...
        // das führt dann zu unschönen ergebnissen, 1x registrieren wäre ok, so scheint mir...
        if !fourOfAKindAlreadySet {
            user.fourOfAKind.addListener(listener: self, method: MoveLieHandler.onFourOfAKind, name: "MoveLieHandler.onFourOfAKind")
        }
        
        user.lie.addListener(listener: self, method: MoveLieHandler.playerLied, name: "MoveLieHandler.playerLied")
        user.dontBelieve.addListener(listener: self, method: MoveLieHandler.playerDidNotBelieve, name: "MoveLieHandler.playerDidNotBelieve")
        
        return user
    }
    //MoveLieHandlerDelegate//
    func playerLied(moveLie: MoveLieEvent){
        
        for n in 0..<moveLie.cards.count{
            self.carddeck.append(card: moveLie.cards[n])
        }
        print("[MoveLieHandler.playerLied]: CardDeck=\(self.carddeck.cards.count), moveCardsCount=\(moveLie.cards.count), nach dem Zug")//self.gameData.moveCardsCount
        self.moveCardsCount = moveLie.cards.count //moveCards
        self.moveCardType = moveLie.getMoveCardType()
        moveLie.cards.removeAll()
        
        //TODO: hier muss noch geprüft werden, ob dadurch der vorherige Spieler seine Karten losgeworden ist,
        //dann den vorherigen Spieler aus dem Spiel nehmen und Spielendelogik prüfen
        //TODO: kapseln!
        //Warum die Class-Method benutzen, gibt eine viel schönere, schlankere Object-Method
        //if(gameMaster.users[Gamemaster.getPreviousPlayer(activeUserId: gameMaster.activeUserId, userCount: gameMaster.users.count)].cards.count == 0) {
        if(self.users[self.getPreviousPlayer()].cards.count == 0) {
            //gameMaster.finishedUsers.append(gameMaster.users[Gamemaster.getPreviousPlayer(activeUserId: gameMaster.activeUserId, userCount: gameMaster.users.count)])
            self.finishedUsers.append(self.users[self.getPreviousPlayer()])
            //gameMaster.users.remove(at: Gamemaster.getPreviousPlayer(activeUserId: gameMaster.activeUserId, userCount: gameMaster.users.count))
            self.users.remove(at: self.getPreviousPlayer())
        }
        // wenn es noch mehr als einen Spieler gibt, geht es weiter
        if (self.users.count > 1) {
            //self.emitNextPlayer(nextPlayer: true) //passiert durch UI Button
            self.turnFinished = true
        }
        else{
            //Spielende
            self.gameStarted = false
            print("[MoveLieHandler.playerLied]: Spielende nach Lüge")
        }
        
        if GameSettings.autoPlay {
            self.emitNextPlayer(nextPlayer: true) //passiert durch UI Button
            //self.turnFinished = true
        }
    }
    
    func playerDidNotBelieve(dontBelieve: Bool){
        var losingPlayer: Int = 0
        print("[MoveLieHandler.playerDidNotBelieve]: CardDeck=\(self.carddeck.cards.count) nach dem Zug")
        //TODO: dokumentieren, was hier geprüft wird, was habe ich mir nur dabei gedacht???
        //if (self.checkNoBelieveSituation() == false) { return }
        //wenn der vorherige Spieler gelogen hat, ist er der "losingPlayer"
        if (self.didPreviousPlayerLie()) {
            //losingPlayer = Gamemaster.getPreviousPlayer(activeUserId: gameMaster.activeUserId, userCount: gameMaster.users.count)
            losingPlayer = self.getPreviousPlayer()
        }
        else {
            //print("MoveLieHandler: \(self.gameData.users[Gamemaster.getPreviousPlayer(activeUserId: self.gameData.activeUserId, userCount: self.gameData.users.count)].name) hat die Wahrheit gesagt.")
            losingPlayer = self.activeUserId
        }
        print("[MoveLieHandler.playerDidNotBelieve]: Spieler \(self.users[losingPlayer].name) bekommt \(self.carddeck.cards.count) Karten")
        //print("MoveLieHandler: \(self.gameData.users[losingPlayer].name) hat verloren und bekommt \(self.gameData.carddeck.cards.count) Karten")
        
        self.moveCards(losingPlayer)
        self.continueGame(losingPlayer)
    }
    
    func onFourOfAKind(moveLie: MoveLieEvent){
        //ich glaube, hier wird für beide User durchlaufen, auch wenn nur ein User das Event geraised hat
        //deshalb auf User prüfen... aber wie?
        //Oder: prüfen, ob die gleichen Karten schon in cardsOutOfGame exitieren!
        var cardAlreadyOutOfGame: Bool = false
        
        print("[Gamemaster.onFourOfAKind]: nehme \(moveLie.cards.count) Karten aus dem Spiel (von User \(moveLie.userName))")
        for n in 0..<moveLie.cards.count{
            for m in 0..<self.cardsOutOfGame.cards.count{
                if moveLie.cards[n].name == self.cardsOutOfGame.cards[m].name {
                    cardAlreadyOutOfGame = true
                }
            }
            if cardAlreadyOutOfGame == false{
                self.cardsOutOfGame.cards.append(moveLie.cards[n])
            }
            
            cardAlreadyOutOfGame = false //zurücksetzen für nächste Karte
        }
        if self.carddeck.cards.isEmpty {
            self.isGameConsistent()
        }
    }
    
    
    func emitNextPlayer(nextPlayer: Bool){
        let nextPlayerEvent = NextPlayerEvent(nextPlayer: nextPlayer)
        self.nextPlayerEvent.emit(data: nextPlayerEvent)
    }
    
    private func moveCards(_ losingPlayer: Int){
        var lastCard: Bool = false
        var cardsToBeGiven: [Card] = self.carddeck.cards
        self.carddeck.cards.removeAll()
        
        for n in 0..<cardsToBeGiven.count{
            if n == cardsToBeGiven.count-1{
                lastCard = true
            }
            self.users[losingPlayer].getCard(card: cardsToBeGiven[n], lastCard)
            print("[MoveLieHandler.moveCards]: Spieler \(self.users[losingPlayer].name) bekommt \(cardsToBeGiven[n].name)")
        }
        //self.gameData.carddeck.printCardDeckSize()
        
        self.moveCardsCount = 0
        self.moveCardType = ""
        MoveLieEvent.moveCardType = self.moveCardType
    }
    
    private func continueGame(_ losingPlayer: Int){
        //wenn der aktuelle Spieler verloren hat, ist der nächste dran.
        if (losingPlayer == self.activeUserId){
            print("[MoveLieHandler.continueGame]: LosingPlayer = \(self.users[self.activeUserId])")
            //wenn der vorherige Spieler keine Karten hat, aus dem Spiel nehmen
            //if (self.users[Gamemaster.getPreviousPlayer(activeUserId: gameMaster.activeUserId, userCount: gameMaster.users.count)].cards.count == 0){
            if(self.users[self.getPreviousPlayer()].cards.count == 0){
                // der vorherige Spieler hat nicht gelogen und keine Karten mehr => er ist fertig
                //TODO: kapseln
                print("[MoveLieHandler.continueGame]: Spieler \(self.users[self.getPreviousPlayer()].name) hat keine Karten mehr und ist fertig")
                self.finishedUsers.append(self.users[self.getPreviousPlayer()])
                self.users.remove(at: self.getPreviousPlayer())
            }
            // wenn es noch mehr als einen Spieler gibt, geht es weiter
            if (self.users.count > 1 && GameSettings.autoPlay) {
                print("[MoveLieHandler.continueGame]: Weiter geht es, der nächste Spieler ist dran")
                self.emitNextPlayer(nextPlayer: true) //passiert durch UI Button
            }
            else{
                //Spielende
                self.gameStarted = false
                if self.users.count > 0 {
                    self.finishedUsers.append(self.users[0]) //letzten Spieler auch aufs Treppchen
                    self.users.remove(at: 0)
                }
                print("[MoveLieHandler.continueGame]: Spielende nach Nicht-Glauben.")
                //self.gameData.finishedUsers.append(self.gameData.users[0])
            }
            //print("MoveLieHandler: Spielstatus=\(self.gameData.gameStarted)")
        }
        //wenn der vorherige Spieler verloren hat, darf der aktuelle Spieler herauskommen
        else {
            print("[MoveLieHandler.continueGame]: LosingPlayer = \(self.users[self.getPreviousPlayer()])")
            self.emitNextPlayer(nextPlayer: false)
        }
    }
    
    /*func checkNoBelieveSituation() -> Bool {
        if self.moveCardsCount > self.carddeck.cards.count{
            print("Gamemaster: Es wurden mehr Karten (\(self.moveCardsCount)) gelegt als im Carddeck sind")
            return false
            
        }else if self.moveCardsCount == 0 {
            print("[Gamemaster.checkNoBelieveSituation]: Es wurden keine Karten gelegt!?!")
            return false
        }else{
            //self.gameData.carddeck.printCardDeck()
            return true
        }
    }*/
    
    private func didPreviousPlayerLie() -> Bool {
        var cardsIndex: Int
        
        for n in 0..<self.moveCardsCount{
            cardsIndex = self.carddeck.cards.count-n-1 //moveCardsCount-n
            print("[Gamemaster.didPreviousPlayerLie] Vergleiche \(self.carddeck.cards[cardsIndex].name ) mit \(self.moveCardType)")
            
            if self.carddeck.cards[cardsIndex].cardtype.cardtype != self.moveCardType{
                print("[Gamemaster.didPreviousPlayerLie]: der vorherige Spieler hat gelogen. Er legte \(self.carddeck.cards[cardsIndex].cardtype.cardtype) obwohl \(self.moveCardType) angesagt war.")
                return true
            }
            else{
                print("[Gamemaster.didPreviousPlayerLie]: der vorherige Spieler hat die Wahrheit gesagt.")
            }
        }
        return false
    }
}
