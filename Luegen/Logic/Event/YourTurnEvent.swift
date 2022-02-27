//
//  YourTurn.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 24.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class YourTurnEvent{
    var name : String = ""
    var previousUserCardsCount: Int = 0
    
    init(name: String, previousUserCardsCount: Int){
        self.name = name
        self.previousUserCardsCount = previousUserCardsCount
    }
    init(currentUser: User, previousUser: User){
        self.name = currentUser.name
        self.previousUserCardsCount = previousUser.cards.count
        
        //print("[YourTurnEvent]: jetzt ist \(currentUser.name) dran (mit \(currentUser.cards.count) Karten)")
        //print("[YourTurnEvent]: es war \(previousUser.name) dran (mit \(previousUser.cards.count) Karten)")
    }
}
