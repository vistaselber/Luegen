//
//  DropdownView.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 16.09.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

struct DropdownView: View {

    @State var expand = false
    @ObservedObject var gamemaster: Gamemaster
    @ObservedObject var ddvData : DropdownViewData
    /*
    @State var selectedCards: [UUID] = []
    @State var selectedCardType: String = ""
    @State var cardTypes: [CardType] = CardType.getCardTypes(selectable: true)
    @State var moveLie : Bool = false
    */
    
    var body: some View {
        VStack{
            CardsView(gamemaster: gamemaster, ddvData: ddvData)
            HStack{
                Button("Karten legen"){
                    onKartenLegen()
                }.disabled(!(self.ddvData.selectedCardType != "" && self.ddvData.selectedCards.count > 0))
                .font(.system(size: 15))
                Text("|")
                Button("Ich glaube dir nicht"){
                    onIchGlaubeDirNicht()
                }.disabled(self.gamemaster.carddeck.cards.count < 1)
                .font(.system(size: 15))
            }
            Text("selectedCardType:\(self.ddvData.selectedCardType), selectedCards:\(self.ddvData.selectedCards.count)").font(.system(size: 10))
            printMove()
        }
    }
    private func onIchGlaubeDirNicht(){
        self.gamemaster.users[self.gamemaster.activeUserId].dontBelieve(dontBelieve: true)
        
        self.ddvData.selectedCards.removeAll()
        self.ddvData.selectedCardType.removeAll()
        self.ddvData.moveLie = false
    }
    
    private func onKartenLegen(){
        self.gamemaster.users[self.gamemaster.activeUserId].lie(moveLie: MoveLieEvent(self.ddvData.selectedCards, self.ddvData.selectedCardType, self.gamemaster.users[self.gamemaster.activeUserId].name))
        self.ddvData.selectedCards.removeAll()
        //self.selectedCardType.removeAll()
        self.ddvData.moveLie = true
    }
    
    private func printMove() -> some View {
        let selectedCardsCount = String(self.gamemaster.moveCardsCount)
        var cardType = ""
        var text: String = ""
        
        if self.gamemaster.moveCardType != "" && self.ddvData.selectedCardType == "" {
            cardType = gamemaster.moveCardType
            self.ddvData.selectedCardType = gamemaster.moveCardType
        }else{
            cardType = self.ddvData.selectedCardType
        }
        
        if(self.gamemaster.moveCardsCount > 0 && self.gamemaster.users.count > 0){
            text = "\(self.gamemaster.users[self.gamemaster.getPreviousPlayer()].name) hat \(selectedCardsCount)  Karten als \(cardType) gelegt!"
        }else{
            if(self.ddvData.moveLie){
                if self.gamemaster.users.count > 0 {
                    text = "\(self.gamemaster.users[self.gamemaster.getPreviousPlayer()].name) hat dem vorherigen Spieler nicht geglaubt"
                }
            }else{text = "Zug ausstehend"}
        }
        
        return Text("Runde: \(self.gamemaster.turnCount); \(text)").font(.system(size: 10))
    }
}

struct DropdownView_Previews: PreviewProvider {
    @State static var gamemaster: Gamemaster = Gamemaster()//dummy: true
    @State static var ddd: DropdownViewData = DropdownViewData()
    
    static var previews: some View {
        DropdownView(gamemaster: gamemaster, ddvData: ddd)
    }
}
