//
//  CardsView.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 24.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

struct CardsView: View {
    
    @ObservedObject var gamemaster: Gamemaster
    @ObservedObject var ddvData : DropdownViewData
    
    var body: some View {
        HStack{
            //if self.gamemaster.users.count > 1 && self.gamemaster.activeUserId < self.gamemaster.users.count {
                //Text("Karten")
            if self.gamemaster.users.count > 0 {
                List{
                    ForEach(self.gamemaster.users[self.gamemaster.activeUserId].cards) {
                        card in
                        Button(action: {toggleSelectionCards(card: card)}){
                            HStack{
                                Text("\(card.name)").font(.system(size:12))
                                //Spacer()
                                if self.ddvData.selectedCards.contains(card.id) {
                                    Image(systemName: "checkmark").foregroundColor(.accentColor)
                                }
                            }
                        }.tag(card.name)
                    }
                }.disabled(!(self.gamemaster.users.count > 1 && self.gamemaster.activeUserId < self.gamemaster.users.count))
            }
            //else{
            //    Text("?")
                //Text("Anzahl Spieler:\(self.gamemaster.users.count) und Aktiver Spieler:\(self.gamemaster.activeUserId)")
                //Text("und was nun? Anzahl Spieler:\(self.gamemaster.users.count), aktiver Spieler: \(self.gamemaster.activeUserId)")
            //}
            
            //CardTypesView(ctvd: self.ddvData.ctvd)
            CardTypesView(gamemaster: gamemaster, ddvData: ddvData)
            //CardTypesView(gamemaster: self.gamemaster)
        }
    }
    
    private func toggleSelectionCards(card: Card) {
        //var firstIndex : Int = selectedCards.firstIndex(of: card.id)
        //if selectedCards.contains(card.id) {
        if let firstIndex = self.ddvData.selectedCards.firstIndex(of: card.id){
            self.ddvData.selectedCards.remove(at: firstIndex)
        }
        else {
            if (GameSettings.corruptRoundMod){
                self.ddvData.selectedCards.append(card.id)
            }else{
                if self.ddvData.selectedCards.count < 3 { self.ddvData.selectedCards.append(card.id) }
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    @State static var gamemaster: Gamemaster = Gamemaster()//dummy: true
    @State static var dropdownViewData: DropdownViewData = DropdownViewData()
    
    static var previews: some View {
        CardsView(gamemaster: gamemaster, ddvData: dropdownViewData)
    }
}
