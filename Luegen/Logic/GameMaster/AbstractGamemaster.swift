//
//  AbstractGamemaster.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 11.11.21.
//  Copyright © 2021 Jan Hummel. All rights reserved.
//

import Foundation
import Combine

//kann das weg?
/*
enum NoP: String, CaseIterable, Identifiable{
    case one
    case two
    case three
    case four
    case five
    case zero
    
    var id: String { self.rawValue }
}
*/

class AbstractGamemaster : ObservableObject {    
    //@Published var gameData : GameData
    
    var playerFactory: PlayerFactory
    
    //Event
    let yourTurn = Event<YourTurnEvent>()//Event<YourTurnEvent>()
    var turnCount = 0
    //var moveLieHandler: MoveLieHandler
    @Published var turnFinished: Bool = false
    
    //GameData
    var carddeck: CardDeck
    var cardsOutOfGame: CardDeck
    var users: [User] = []
    var activeUserId: Int = 0
    var moveCardsCount: Int = 0
    var moveCardType: String = ""
    @Published var finishedUsers: [User] = []
    @Published var gameStarted : Bool = false

    //MoveLieHandler
    let nextPlayerEvent = Event<NextPlayerEvent>()

    
    init(){
        playerFactory = PlayerFactory()
        self.carddeck = CardDeck()
        self.cardsOutOfGame = CardDeck()
        self.nextPlayerEvent.addListener(listener: self as! Gamemaster, method: Gamemaster.onNextPlayer, name: "Gamemaster.onNextPlayer")
        
        self.cardsOutOfGame.cards.removeAll()
    }
    init(_ noP: Int){
        self.playerFactory = PlayerFactory()
        self.playerFactory.numberOfUsersToBe = noP
        self.carddeck = CardDeck()
        self.cardsOutOfGame = CardDeck()

        self.nextPlayerEvent.addListener(listener: self as! Gamemaster, method: Gamemaster.onNextPlayer, name: "Gamemaster.onNextPlayer")
        
        self.cardsOutOfGame.cards.removeAll()
        self.setNumberOfPlayers(noP)
    }
    
    func setNumberOfPlayers(_ noP: Int){
        print("Gamemaster: setze Anzahl der Spieler: \(noP)")
        self.playerFactory.numberOfUsersToBe = noP
        for i in 0..<noP{
            self.playerFactory.currentPlayerType.append(0)
        }
    }

    func printGameStatus(){
        for i in 0..<self.users.count{
            print("Gamemaster: Spielstatus \(self.gameStarted), Spielername: \(self.users[i].name)")
            self.users[i].printCardDeck()
        }
    }
    
    
    func setUsers(){
        self.users.removeAll()
        self.users = PlayerFactory.buildUsers(withListerners: true, playerFactory: self.playerFactory, self as! MoveLieHandler, self as! Gamemaster)
        self.setYourTurnHandler()
    }
    
    func setYourTurnHandler(){
        for i in 0..<self.users.count{
            self.yourTurn.addListener(listener: self.users[i], method: YourTurn.onYourTurn, name: "YourTurn.onYourTurn")
        }
    }
    
    func reset(){
        self.carddeck.resetCardDeck()
        self.cardsOutOfGame.cards.removeAll()
        self.users.removeAll()
        self.activeUserId = 0
        self.moveCardsCount = 0
        self.moveCardType = ""
        self.finishedUsers.removeAll()
        self.gameStarted = false
    }
    
    func toggleGameStarted(){
        self.gameStarted.toggle()
    }
    
    func isGameConsistent() -> Bool {
        let sumCards = 32
        var sumCardsPlayer = 0
        
        for i in 0..<self.users.count{
            sumCardsPlayer += self.users[i].cards.count
        }
        
        if sumCards == (sumCardsPlayer + self.carddeck.cards.count + self.cardsOutOfGame.cards.count) {
            return true
        }
        else {
            print("[Gamemaster]: Summe der Spielkarten: \(sumCards)")
            print("[Gamemaster]: _Summe der Spielerkarten: \(sumCardsPlayer)")
            print("[Gamemaster]: _Karten auf Kartenstapel: \(self.carddeck.cards.count)")
            print("[Gamemaster]: _Karten aus dem Spiel: \(self.cardsOutOfGame.cards.count)")
            print("[Gamemaster]: Summe der Karten im Spiel: \(sumCardsPlayer + self.carddeck.cards.count + self.cardsOutOfGame.cards.count)")
            
            return false
            
        }
    }
    
    func checkPlayersCardsLeft() -> Bool{
        for i in 0..<self.users.count{
            if self.users[i].cards.count > 0 { return true }
        }
        print("Gamemaster: keine Spieler mit Karten übrig...")
        return false
    }
    
    func getPreviousPlayer() -> Int {
        var previousPlayer: Int = 0
        if self.activeUserId == 0 { previousPlayer = self.users.count-1 }
        else { previousPlayer =  self.activeUserId-1 }
        
        if previousPlayer < 0 { previousPlayer = 0}
        return previousPlayer
    }
    
    static func getPreviousPlayer(activeUserId: Int, userCount: Int) -> Int{
        var previousPlayer: Int = 0
        if activeUserId == 0 { previousPlayer = userCount-1 }
        else { previousPlayer =  activeUserId-1 }
        
        if previousPlayer < 0 { previousPlayer = 0}
        return previousPlayer
    }
}
