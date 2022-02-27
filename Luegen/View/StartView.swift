//
//  StartView.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 31.08.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        StartMenu()//gamemaster: Gamemaster(dummy: false)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()//gamemaster: gamemaster
    }
}
