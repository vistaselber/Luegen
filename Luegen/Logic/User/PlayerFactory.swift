//
//  PlayerFactory.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 20.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import Foundation

class PlayerFactory : ObservableObject {
    
    static var playerType : [String] = ["User", "Simple Computer", "DemoComputer1", "DemoComputer2"]
    static var user: Int = 0
    static var simpleComputer: Int = 1
    
    @Published var numberOfUsersToBe: Int = 0
    @Published var currentPlayerType: [Int] = []
    @Published var users: [User] = []
    
    init(){
    }
    
    static func buildUser(playerType: Int, number: Int, gamemaster: Gamemaster) -> User {
        switch playerType{
        case 0:
            return User("User \(number)")
        case 1:
            return SimpleComputer("Computer\(number)")
        case 2:
            return DemoComputer1("DemoComputer\(number)", gamemaster: gamemaster)
        case 3:
            return DemoComputer2("DemoComputer\(number)", gamemaster: gamemaster)
        default: 
            return SimpleComputer("Computer\(number)")
        }
    }
    
    static func buildUserWithListener(playerType: Int, number: Int, _ moveLieHandler: MoveLieHandler, _ gamemaster: Gamemaster) -> User {
        
        //print("[PlayerFactory.buildUserWithListener]: Baue einen User vom Typ \(PlayerFactory.playerType[playerType])")
        
        var user : User = PlayerFactory.buildUser(playerType: playerType, number: number, gamemaster: gamemaster)
        //var moveLieHandler = moveLieHandler //MoveLieHandler()
        /*user.lie.addListener(listener: self, method: Gamemaster.playerLied)
        user.dontBelieve.addListener(listener: self, method: Gamemaster.playerDidNotBelieve)
        user.fourOfAKind.addListener(listener: self, method: Gamemaster.onFourOfAKind)*/
        //user = moveLieHandler.addListenerToUser(user: user, fourOfAKindAlreadySet: false)
        user = gamemaster.addListenerToUser(user: user, fourOfAKindAlreadySet: false)
        
        return user
    }
    
    static func buildUsers(withListerners:Bool, playerFactory: PlayerFactory, _ moveLieHandler: MoveLieHandler, _ gamemaster: Gamemaster) ->[User]{
        var user: User
        var users: [User] = []
        
        for i in 0..<playerFactory.numberOfUsersToBe{
            //print("[PlayerFactory.buildUsers]: Baue einen User vom Typ \(PlayerFactory.playerType[playerFactory.currentPlayerType[i]]), mit Listeners:\(withListerners.description)")
            
            if withListerners == true {
            user = PlayerFactory.buildUserWithListener(playerType: playerFactory.currentPlayerType[i], number: i+1, moveLieHandler, gamemaster)
            }
            else{
                user = PlayerFactory.buildUser(playerType: playerFactory.currentPlayerType[i], number: i+1, gamemaster: gamemaster)
            }
            users.append(user)
        }
        
        return users
    }
    
    func reset(){
        self.numberOfUsersToBe = 0
        self.currentPlayerType.removeAll()
        self.users.removeAll()
    }
}
