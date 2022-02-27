//
//  GameDataStruct.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 03.12.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

struct GameDataSruct {
    var carddeck: CardDeck
    var cardsOutOfGame: CardDeck
    var users: [User] = []
    var activeUserId: Int = 0
    var moveCardsCount: Int = 0
    var moveCardType: String = ""
    //var playerFactory: PlayerFactory
    var finishedUsers: [User] = []
    var gameStarted : Bool = false
    //@Published var ddvData : DropdownViewData
}
