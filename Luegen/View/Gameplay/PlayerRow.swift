//
//  PlayerRow.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 06.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

struct PlayerRow: View {
    
    @ObservedObject var gamemaster: Gamemaster
    @ObservedObject var user: User
    var index: Int
    //@State var userId: Int //= 0
    
    var body: some View {
        //makeByUser()
        makeByGamemaster()
    }


    func makeByUser() -> some View {
        VStack{
            //Text("Spieler: \(self.gamemaster.users[userId].name)")
            Text("Spieler: \(self.user.name)").font(.system(size: 15))
            //Text("Anzahl Karten: \(self.gamemaster.users[userId].getNumberOfCards())")
            Text("Anzahl Karten: \(self.user.getNumberOfCards())").font(.system(size: 15))
        }
    }

    func makeByGamemaster() -> some View {
        VStack{
            if self.gamemaster.users.count > 0 {
                //Text("Spieler: \(self.gamemaster.users[userId].name)")
                Text("Spieler: \(self.gamemaster.users[index].name)").font(.system(size: 15))
                //Text("Anzahl Karten: \(self.gamemaster.users[userId].getNumberOfCards())")
                Text("Anzahl Karten: \(self.gamemaster.users[index].getNumberOfCards())").font(.system(size: 15))
            } else{ Text("") }
        }
    }
    
}

struct PlayerRow_Previews: PreviewProvider {
    @State static var gamemaster: Gamemaster = Gamemaster()//dummy: true
    @State static var users: [User] = gamemaster.users
    @State static var user = User("Preview")
    
    static var previews: some View {
        //PlayerRow(gamemaster: gamemaster, userId: 0)//
        PlayerRow(gamemaster: gamemaster, user: user, index: 0)
    }
}
