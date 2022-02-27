//
//  CardTypesViewData.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 17.11.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class CardTypesViewData : ObservableObject{

    @Published var selectedCardType: String
    var cardTypesSel: [CardType]
    var cardTypes: [String]
    
    static var staticCardTypes : [CardType] = CardType.getCardTypes(selectable: true)

    init(){
        cardTypesSel = CardType.getCardTypes(selectable: true)
        cardTypes = CardType.getCardTypes()
        selectedCardType = ""
        /*print("Verfügbare Kartentypen:")
        for ct in cardTypes{
            print("\(ct.cardtype)")
        }*/
    }
}
