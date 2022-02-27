//
//  Move.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 06.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class MoveLieEvent {

    var moveCardsCount: Int = 0
    var moveCards: [UUID] = [UUID()]
    static var moveCardType: String = ""
    var cards: [Card] = []
    var userName: String = ""
    
    init(){
        //print("MoveLie: Instanziierung")
    }
    init(_ moveCards: [UUID], _ moveCardType: String, _ userName: String){
        self.moveCards = moveCards
        self.userName = userName
        if(MoveLieEvent.moveCardType == ""){
            MoveLieEvent.moveCardType = moveCardType
        }
        self.moveCardsCount = moveCards.count
        
        print("MoveLie: Es wurden \(self.moveCardsCount) Karten gelegt, vom Typ \(MoveLieEvent.moveCardType)")
    }
    
    func setMoveCards(moveCards: [UUID]){
        self.moveCards = moveCards
    }
    func setMoveCardType(moveCardType: String){
        //print("MoveLie: set moveCardType to=\(moveCardType)")
        MoveLieEvent.moveCardType = moveCardType
    }
    
    func getMoveCardType() -> String {
        return MoveLieEvent.moveCardType
    }
}
