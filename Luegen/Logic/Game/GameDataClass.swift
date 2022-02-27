//
//  GameDataClass.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 03.12.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation
import Combine

/*extension GameStatus : Identifiable {
    var id: String {
        return self.iso2
    }
    var gameStarted : Bool = false
}
var gameStatusPublisher: AnyPublisher<GameStatus, Never> = {
    let urlSession = URLSession.shared
    let url = URL(string: "https://www.ralfebert.de/examples/countries.json")!

    return urlSession
        .dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: [Country].self, decoder: JSONDecoder())
        .assertNoFailure() // todo: no error handling right now
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()

}()*/

class GameData { //: ObservableObject{
    
    //@Published var gameData : GameDataSruct
    
    static var singleton: GameData = {
        let gamedata = GameData()
        return gamedata
    }()
    //@Published
    var carddeck: CardDeck
    var cardsOutOfGame: CardDeck
    var users: [User] = []
    var activeUserId: Int = 0
    var moveCardsCount: Int = 0
    var moveCardType: String = ""
    //@Published var playerFactory: PlayerFactory
    @Published var finishedUsers: [User] = []
    //var gameStarted : Bool = false
    //var gameStatus = GameStatus()
    @Published var gameStarted : Bool = false
    //@Published var ddvData : DropdownViewData
    
    private var isGameStartedPublisher: AnyPublisher<Bool, Never>{
        $gameStarted
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
            /*.sink{
                print("isGameStartedPublisher: \($gameStarted)")
            }*/
    }
    
    private init(){
        //self.gameData
        //self.gameStarted = self.gameStatus.gameStarted
        carddeck = CardDeck()
        cardsOutOfGame = CardDeck()
        //playerFactory = PlayerFactory()
        //ddvData = DropdownViewData()
        
        //moveLieHandler = MoveLieHandler()
        
        cardsOutOfGame.cards.removeAll()
        
        isGameStartedPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.gameStarted, on:self)
    }
    
    class func getInstance() -> GameData{
        return singleton
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
}
