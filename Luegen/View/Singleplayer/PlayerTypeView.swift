//
//  PlayerTypeView.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 20.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

struct PlayerTypeView: View {
    @ObservedObject var gamemaster: Gamemaster
    @ObservedObject var playerFactory: PlayerFactory
    @State var users: [User] = []
    
    var body: some View {
        HStack{
            ForEach(0..<self.playerFactory.numberOfUsersToBe, id: \.self){ index in
                VStack{
                    Button(action: {togglePlayerType(index:index)}){
                        //TODO: hier trat eine Index out of Bounds Exception auf...
                        Text("\(PlayerFactory.playerType[self.playerFactory.currentPlayerType[index]])")//.font(.system(size:5))
                    }//.tag(PlayerFactory.playerType[self.currentPlayerType])
                    //Text("Player: \(gamemaster.users[index].name)")
                    //Spacer()
                }
            }
        }
    }
    private func togglePlayerType(index: Int){
        /*var user: User = PlayerFactory.buildUser(playerType: playerType, number: index)!
        users.append(user)*/
        let numberOfPlayerTypes : Int = PlayerFactory.playerType.count - 1
        //print("Index (Player): \(index), PlayerType: \(self.gamemaster.currentPlayerType[index]), Anzahl Playertype: \(PlayerFactory.playerType.count)")
        
        if (self.playerFactory.currentPlayerType[index] < numberOfPlayerTypes){
            self.playerFactory.currentPlayerType[index] += 1
        }
        else { self.playerFactory.currentPlayerType[index] = 0 }
    }

}

struct PlayerTypeView_Previews: PreviewProvider {
    @State static var gamemaster: Gamemaster = Gamemaster()//dummy: true
    @State static var user: User = User("Jan Hummel")
    @State static var playerFactory = PlayerFactory()
    
    static var previews: some View {
        PlayerTypeView(gamemaster: gamemaster, playerFactory: playerFactory)
    }
}
