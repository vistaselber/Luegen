//
//  CardHolder.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 05.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class CardHolder : ObservableObject{
    
    var cards: [Card] // = [] //Published
    
    init(){
        cards = []
    }
    
    func printCardDeck(){
        print("CardHolder: Kartendeck unsortiert")
        for c in cards{
            print("Karte = \(c.name), Sortierung \(c.sort)")
        }
    }
    
    func printCardDeckSorted(){
        print("Cardholder: Kartendeck sortiert")
        for i in 0..<self.cards.count {
            for c in cards{
                if c.sort == i {
                    print("Karte = \(c.name), Sortierung \(c.sort)")
                }
            }
        }
    }
    
    func printCardDeckSize(){
        print("CardHolder: Anzahl Karten im Kartenstapel: \(cards.count)")
    }
    
    func getNumberOfCards() -> Int {
        return cards.count
    }
}
