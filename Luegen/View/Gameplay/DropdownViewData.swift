//
//  DropdownViewData.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 24.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class DropdownViewData : ObservableObject{
    
    static var singleton: DropdownViewData = {
        let dropDownViewData = DropdownViewData()
        return dropDownViewData
    }()
    
    @Published var selectedCards: [UUID] = []
    @Published var moveLie : Bool = false
    
    //@Published var ctvd : CardTypesViewData
    @Published var selectedCardType: String
    var cardTypesSel: [CardType]
    var cardTypes: [String]
    
    static var staticCardTypes : [CardType] = CardType.getCardTypes(selectable: true)

    init(){
        /*print("Verfügbare Kartentypen:")
        for ct in cardTypes{
            print("\(ct.cardtype)")
        }*/
        
        //ctvd = CardTypesViewData()
        cardTypesSel = CardType.getCardTypes(selectable: true)
        cardTypes = CardType.getCardTypes()
        selectedCardType = ""
    }
    
    class func getInstance() -> DropdownViewData{
        return singleton
    }
}
