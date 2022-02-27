//
//  GameView.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 31.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var gamemaster: Gamemaster
    @State private var contentViewActive: Bool = false
    
    //let numberOfPlayer : Int = 0
    @State var noP : Int = 0
    @State var gameInitialized: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                StepperView(gamemaster: gamemaster, noP: $noP)
                PlayerTypeView(gamemaster: gamemaster, playerFactory: gamemaster.playerFactory)
                
                /*if self.gameInitialized == false && self.gamemaster.playerFactory.numberOfUsersToBe > 0 {
                    Button("Spiel initialisieren"){
                        self.gamemaster.setUsers()
                        self.gameInitialized = true
                    }.disabled(self.gameInitialized)
                }// else { Text("hier wollte ich nicht landen") }*/
                //Text(\(self.gamemaster.playerFactory.numberOfUsersToBe))
                
                //, noP: self.$noP
                NavigationLink(destination: ContentView(gamemaster: self.gamemaster), isActive: $contentViewActive){
                    Text("Start the Game")
                }.simultaneousGesture(TapGesture().onEnded{
                    print("Got Tap")
                    self.contentViewActive.toggle()
                    self.gamemaster.setUsers()
                })//.disabled(self.gamemaster.playerFactory.numberOfUsersToBe <= 0)
                /*.onAppear {
                    if self.contentViewActive == false{
                        self.gamemaster.initGame()
                    }
                }*/
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("Hauptmenu", action : {
            self.gamemaster.initGame()
            self.mode.wrappedValue.dismiss()
            //self.noP = 0
            self.gameInitialized = false
        }))
    }
}

struct GameView_Previews: PreviewProvider {
    @State static var gamemaster: Gamemaster = Gamemaster()//dummy: true
    static var previews: some View {
        GameView(gamemaster: gamemaster)//gamemaster: gamemaster
    }
}
