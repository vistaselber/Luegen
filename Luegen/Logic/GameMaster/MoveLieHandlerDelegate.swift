//
//  MoveLieHandlerDelegate.swift
//  Luegen
//
//  Created by Jan Hummel on 27.02.22.
//

import Foundation

protocol MoveLieHandlerDelegate: AnyObject{
    
    func onFourOfAKind(moveLie: MoveLieEvent)
    func playerLied(moveLie: MoveLieEvent)
    func playerDidNotBelieve(dontBelieve: Bool)
}
