//
//  CardType.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 05.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class CardType : Identifiable{
    static var ass: String = "Ass"
    static var king: String = "Koenig"
    static var queen: String = "Dame"
    static var jack: String = "Bube"
    static var ten: String = "Zehn"
    static var nine: String = "Neun"
    static var eight: String = "Acht"
    static var seven: String = "Sieben"
    
    static var types = [
        [ass, 11],
        [king, 4],
        [queen, 3],
        [jack, 2],
        [ten, 10],
        [nine, 9],
        [eight, 8],
        [seven, 7]
    ]
    
    var cardtype: String
    var value = 0
    var id : UUID //= UUID()

    init(cardtype: String){
        self.cardtype = cardtype
        for ct in CardType.types{
            if ct[0] as! String == cardtype {
                value = ct[1] as! Int
            }
        }
        id = UUID()
    }
    
    static func getCardTypes() -> [String] {
        var cardTypes: [String] = []
        for ct in CardType.types{
            cardTypes.append(ct[0] as! String)
        }
        return cardTypes
    }
    
    static func getCardTypes(selectable: Bool) -> [CardType] {
        var cardTypes: [CardType] = []
        
        if(selectable){
            for ct in CardType.types{
                if ct[0] as! String != self.ass {
                    cardTypes.append(CardType(cardtype: ct[0] as! String))
                }
            }
        }
        return cardTypes
    }
}
