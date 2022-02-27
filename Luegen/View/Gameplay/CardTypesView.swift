//
//  CardTypesView.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 24.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

struct CardTypesView: View {
    
    @ObservedObject var gamemaster: Gamemaster
    @ObservedObject var ddvData : DropdownViewData
    //@ObservedObject var ctvd : CardTypesViewData
    
    var body: some View {
        
        List{
            ForEach(self.ddvData.cardTypesSel) {
                type in
                Button(action: {toggleSelectionCardType(ct: type)}){
                    HStack{
                        Text("\(type.cardtype)").font(.system(size:12))
                        //Spacer()
                        markCardType(cardType: type.cardtype)
                    }
                }
            }
        }
    }
    
    private func toggleSelectionCardType(ct: CardType) {
        //TODO:
        //Ziel: wenn ein Spieler einen CardType angesagt hat,
        //müssen alle folgenden Spieler den CardType bedienen
        if(MoveLieEvent.moveCardType == "") {
            self.ddvData.selectedCardType = ct.cardtype
            //MoveLie.moveCardType = self.ddvData.selectedCardType
        }else{ self.ddvData.selectedCardType = MoveLieEvent.moveCardType }
    }
    
    private func markCardType(cardType: String) -> some View{
        //let someView: Image  //= Image(systemName: "checkmark")
        
        //TODO: durch diese Codingzeile wird eine Endlosschleife erzeugt...!?
        //if(MoveLie.moveCardType != "") { self.ddvData.selectedCardType = MoveLie.moveCardType }
        
        /*if self.gamemaster.ddvData.selectedCardType == "" {
            self.gamemaster.ddvData.selectedCardType = MoveLie.moveCardType
        }*/
        if self.ddvData.selectedCardType == cardType {
            //someView = Image(systemName: "checkmark")//.foregroundColor(.accentColor) as! Image
            return Image(systemName: "checkmark")
            //return Image(systemName: "chechmark")
        }else{ return Image(systemName: "square") }
    }
}

struct CardTypesView_Previews: PreviewProvider {
    @State static var gamemaster: Gamemaster = Gamemaster()//dummy: true
    @State static var dropdownViewData: DropdownViewData = DropdownViewData()
    @State static var ctvd : CardTypesViewData = CardTypesViewData()
    
    static var previews: some View {
        //CardTypesView(ctvd: ctvd)
        CardTypesView(gamemaster: gamemaster, ddvData: dropdownViewData)
    }
}
