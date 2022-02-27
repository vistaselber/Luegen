//
//  DemoGameMaster.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 11.11.21.
//  Copyright © 2021 Jan Hummel. All rights reserved.
//

import Foundation
import Combine

class DemoGameMaster: Gamemaster{
    
    
    static func initDemoGamemaster() -> DemoGameMaster{
        var demoGamemaster = DemoGameMaster() // = DemoGameMaster.getInstance() as! DemoGameMaster
        demoGamemaster.initDemo()
        return demoGamemaster
    }
    
    @Published var demo = true
    private var isDemoPublisher: AnyPublisher<Bool, Never> {
        $demo
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    override init(){
        super.init()
        isDemoPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.demo, on: self)
    }
    
    override func initGame(){
        super.initGame()
        self.initDemo()
    }
    
    private func initDemo(){
        
        switch GameSettings.demoMode{
        case 1: self.initDemoGameplayEasy()
        case 2: self.initDemoGameplayRandom()
        default: self.initDemoGameplayEasy()
        }
    }
    
    private func initDemoGameplayEasy(){
        //nur PlayerType 2 und 3 -> Demo Computer
        self.playerFactory.currentPlayerType.append(2)
        self.playerFactory.currentPlayerType.append(3)
        
        self.playerFactory.numberOfUsersToBe = self.playerFactory.currentPlayerType.count
        self.setUsers()

    }
    
    private func initDemoGameplayRandom(){
        //nur PlayerType 2 und 3 -> Demo Computer
        self.playerFactory.currentPlayerType.append(Int.random(in: 2..<4))
        self.playerFactory.currentPlayerType.append(Int.random(in: 2..<4))
        self.playerFactory.currentPlayerType.append(Int.random(in: 2..<4))
        
        self.playerFactory.numberOfUsersToBe = self.playerFactory.currentPlayerType.count
        self.setUsers()
    }
    
}
