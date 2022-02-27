//
//  StepperView.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 06.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

struct StepperView: View {
    
    @ObservedObject var gamemaster: Gamemaster
    @Binding var noP : Int
    
    var body: some View {
        /*Stepper(onIncrement: incrementStep, onDecrement: decrementStep,     ){
            Text("Anzahl Spieler: \(self.noP)")
        }*/
        Stepper{
            Text("Anzahl Spieler: \(self.noP)")
        } onIncrement: {
            incrementStep()
        } onDecrement: {
            decrementStep()
        }
    }
    
    func initStep() {
        self.noP = self.gamemaster.playerFactory.numberOfUsersToBe
    }
    
    func incrementStep() {
        noP += 1
        if (noP > 10){ noP = 0}
        self.gamemaster.setNumberOfPlayers(noP)
    }
    func decrementStep() {
        /*if noP > 0 { noP -= 1 }
        else { noP = 0 }*/
        
        if (noP < 1){ noP = 10}
        else{ noP -= 1 }
        self.gamemaster.setNumberOfPlayers(noP)
    }
}

struct StepperView_Previews: PreviewProvider {
    @State static var gamemaster: Gamemaster = Gamemaster()//dummy: true
    @State static var noP : Int = 0
    static var previews: some View {
        StepperView(gamemaster: gamemaster, noP: $noP)
    }
}
