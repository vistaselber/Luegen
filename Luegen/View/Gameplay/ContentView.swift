//
//  ContentView.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 03.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//
/*
 https://stackoverflow.com/questions/59317034/how-to-set-text-for-textfield-in-swiftui-on-button-click
 */

import SwiftUI
import Combine

struct ContentView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    //@State var gamemaster: Gamemaster
    @ObservedObject var gamemaster: Gamemaster
    @ObservedObject var ddd: DropdownViewData = DropdownViewData.getInstance()
    
    var body: some View {

        VStack{
            makeHeader()
            makeBody()
        }
    }
    
    func makeHeader() -> some View {
        VStack{
            Text("Anzahl Karten im Kartendeck: \(self.gamemaster.carddeck.cards.count)").font(.system(size: 10))
            Text("Anzahl der Karten, die aus dem Spiel sind: \(self.gamemaster.cardsOutOfGame.cards.count)").font(.system(size: 10))
            Text("Anzahl User: \(self.gamemaster.users.count)").font(.system(size: 10))
            //Spacer()
                .navigationBarBackButtonHidden(false)
                .navigationBarItems(
                    leading:
                        HStack{
                            Button("Init", action : {
                                self.gamemaster.initGame()
                            })

                            Button("Deal", action: {
                                self.gamemaster.gameStarted = true
                                self.gamemaster.deal()
                            }).disabled(self.gamemaster.gameStarted)
                            
                            Button("NextStep>", action: {
                                if self.gamemaster.turnCount < 1 {
                                    self.gamemaster.emitNextPlayer(nextPlayer: false)
                                }
                                else{
                                    self.gamemaster.emitNextPlayer(nextPlayer: true)
                                }
                            }).disabled(!self.gamemaster.turnFinished && !GameSettings.autoPlay && !self.gamemaster.gameStarted)

                        }
                )
        }
    }
    func makeBody() -> some View{
        VStack(){
            Text("Spiel gestartet: \(self.gamemaster.gameStarted.description)").font(.system(size: 8))
            Text("fertige Spieler: \(self.gamemaster.finishedUsers.count)").font(.system(size: 8))
            if(self.gamemaster.gameStarted){
                makePlayerRow()
                DropdownView(gamemaster: self.gamemaster, ddvData: ddd)
            }
            else{
                ForEach(0..<self.gamemaster.finishedUsers.count, id: \.self){ index in
                    Text("\(index+1).: \(self.gamemaster.finishedUsers[index].name)")
                }
            }
        }
    }
    
    func makePlayerRow() -> some View {
        HStack{
            ForEach(0..<self.gamemaster.users.count, id: \.self){
                index in
                //PlayerRow(gamemaster: self.gamemaster, userId: index)
                PlayerRow(gamemaster: gamemaster, user: self.gamemaster.users[index], index: index)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var gamemaster: Gamemaster = Gamemaster()//dummy: true
    @State static var noP: Int = 0
    
    static var previews: some View {
        ContentView(gamemaster: gamemaster)//, noP: $noP
    }
}
