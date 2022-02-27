//
//  CardColor.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 05.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class CardColor{
    
    static var heart: String = "Herz"
    static var spade: String = "Pik"
    static var clubs: String = "Kreuz"
    static var diamond: String = "Karo"
    
    static var colors = [
        [clubs, 12],
        [spade, 11],
        [heart, 10],
        [diamond, 9]
    ]
    
    var color: String
    var rank = 0

    
    init( color: String){
        self.color = color
        for c in CardColor.colors{
            if c[0] as! String == color {
                rank = c[1] as! Int
            }
        }
    }
    
}
