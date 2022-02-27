//
//  StartMenu.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 04.12.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

//https://www.hackingwithswift.com/quick-start/swiftui/building-a-menu-using-list

struct StartMenu: View {
    @State private var gameViewActive: Bool = false
    @State private var contentViewActive: Bool = false
    @State private var mpOverviewActive: Bool = false
    
    var body: some View {
        
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationView {
            List {
                NavigationLink(destination: ContentView(gamemaster: DemoGameMaster.initDemoGamemaster()), isActive: $contentViewActive){
                    Text("Demo")
                }
                .simultaneousGesture(TapGesture().onEnded{
                    print("Got Tap for Demo")
                    self.contentViewActive.toggle() //wofür?
                })
                
                /*NavigationLink(destination: GameView(gamemaster: gamemaster), isActive: $gameViewActive){
                    Text("Single Player")
                }.simultaneousGesture(TapGesture().onEnded{
                    print("Got Tap for Single PLayer")
                    self.gameViewActive.toggle()
                })*/
                
                Text("Einstellungen")
            }
            .navigationBarTitle("Hauptmenu")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct StartMenu_Previews: PreviewProvider {
    //@State static var gamemaster: Gamemaster = Gamemaster(dummy: true)
    static var previews: some View {
        StartMenu()//gamemaster: gamemaster
    }
}
