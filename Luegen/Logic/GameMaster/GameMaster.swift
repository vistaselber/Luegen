//
//  GameMaster.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 06.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation
import Combine

class Gamemaster: MoveLieHandler{
    
    override init(){
        super.init()
    }
    override init(_ noP: Int){
        super.init(noP)
    }
    
    func initGame(){
        print("Gamemaster: Kartenstapel hat aktuell \(self.carddeck.cards.count) Karten")
        
        if self.turnCount > 0{
            self.carddeck = CardDeck()
            self.carddeck.resetCardDeck()
            self.cardsOutOfGame.cards.removeAll()
            self.users.removeAll()
            self.finishedUsers.removeAll()
            self.activeUserId = 0
            self.gameStarted = false
            self.reset()
            self.playerFactory.reset()
            self.playerFactory.numberOfUsersToBe = 1
            self.turnCount = 0
        }
        
        print("+++ Gamemaster: Spiel initialisiert: \(self.carddeck.cards.count) Karten & \(self.users.count) Spieler (Karten aus dem Spiel: \(self.cardsOutOfGame.cards.count)")
    }
    
    func deal(){
        print("Gamemaster: deal!")
        self.carddeck.giveCardsToUsers(users: self.users)
        self.isGameConsistent()
        
        self.startGame()
    }
    
    private func startGame(){
        if self.users.count <= 1 {
            self.gameStarted = false
            return
        }
        
        if GameSettings.randomStartPlayer == true { self.activeUserId = Int.random(in: 0..<self.users.count) }
        else { self.activeUserId = self.users.count - 1 }
        print("GameMaster: startGame, aktiver User: (\(self.activeUserId)) \(self.users[self.activeUserId].name)")
        self.activeUserId = self.nextPlayer(activeUserId: self.activeUserId)
        print("Gamemaster: nächster Spieler = \(self.activeUserId), \(self.users[self.activeUserId].name)")
        
        self.turnFinished = true
        if(GameSettings.autoPlay) {
            self.emitNextPlayer(nextPlayer: true)
        }
    }
    
    func onNextPlayer(nextPlayerEvent: NextPlayerEvent){
        //if !GameSettings.autoPlay { return }
        
        if nextPlayerEvent.nextPlayer == true{
            self.activeUserId = self.nextPlayer(activeUserId: self.activeUserId)
        }
        if self.users.count > 1 {
            print("[Gamemaster.onNextPlayer]: nächster Spieler = \(self.users[self.activeUserId].name)")
            self.turnFinished = false
            self.triggerPlayer()
        }
        else{
            print("[Gamemaster.onNextPlayer]: Spielende")
            self.finishedUsers.append(self.users[0]) //1 Spieler ist immer übrig :)
        }
    }
    
    private func nextPlayer(activeUserId: Int) -> Int {
        var activeUserId = activeUserId
        activeUserId += 1
        //bei Überlauf wieder von vorne anfangen
        if self.users.count <= activeUserId{
            activeUserId = 0
        }
        // Gefahr vor Endlosschleife ... :/
        if (self.users[activeUserId].cards.count == 0) {
            print("Gamermaster.nextPlayer(): \(self.users[activeUserId].name) hat keine Karten mehr, neuer Spieler wird gesucht")
            if (self.checkPlayersCardsLeft() == true) { return nextPlayer(activeUserId: activeUserId) }
            else { return 0 }
        }else { return activeUserId }
        
    }
    
    private func triggerPlayer(){
        //var yourTurnEvent = Event<YourTurnEvent>()
        if self.users[self.activeUserId].cards.count == 0 {
            //eigentlich geht das nicht, hier muss dann mal Spielende sein,
            //sollte eigentlich woanders schon abgefangen sein..
            //.. sehe aber so langsam auch den Wald vor lauter Bäumen nicht mehr
            //und muss mal aufräumen
            print("Gamemaster.triggerPlayer(): Spieler \(self.users[self.activeUserId].name) ist an der Reihe, hat aber keine Karten mehr - abbruch -.-")
            self.gameStarted = false
            return
        }
        self.turnCount += 1
        print("+++ Gamemaster: Runde \(self.turnCount) +++")
        print("Gamemaster: Spieler \(self.users[self.activeUserId].name) ist an der Reihe")
        
        if self.isGameConsistent() == true {
            //let yourTurnData = YourTurnData(name: self.gameData.users[self.gameData.activeUserId].name, previousUserCardsCount: self.gameData.users[self.getPreviousPlayer()].cards.count)//activeUserId
            let yourTurnData = YourTurnEvent(currentUser: self.users[self.activeUserId], previousUser: self.users[self.getPreviousPlayer()])
            
            /*//https://stackoverflow.com/questions/59682446/how-to-trigger-action-after-x-seconds-in-swiftui
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(GameSettings.delay)) {
                self.yourTurn.emit(data: yourTurnData)
            }*/
            //TODO: Events ausschalten weil die Scheiße einfach nicht funktioniert...
            self.yourTurn.emit(data: yourTurnData)
            //self.users[self.activeUserId].onYourTurn(yourTurn: yourTurnData)
            //self.turnFinished = true
        }
        else { print("!!! Spielstatus inkonsistent! Abbruch !!!") }
    }
    
    /*
    func getGameStatus() -> Bool {
        if self.gameStarted == true && self.users.count > 1 {
            return true
        } else { return false }
    }*/
    
}
