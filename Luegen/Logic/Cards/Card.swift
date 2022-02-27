//
//  Card.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 05.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class Card : Identifiable {
    
    var color: CardColor
    var name: String
    var cardtype: CardType
    var sort = 0
    var id : UUID = UUID()
    
    init(_ color: CardColor, _ cardtype: CardType, _ sort: Int){
        self.color = color
        self.cardtype = cardtype
        name = self.color.color + " " + self.cardtype.cardtype
        self.sort = sort
    }
    
}
