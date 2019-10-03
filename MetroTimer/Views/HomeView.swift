//
//  ContentView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 07.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView : View {
    
    var body: some View {
        
        TabView {
            DepartureView()
                .tag(0)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Departures")
                }
            
            SettingsView()
                .tag(1)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#if DEBUG
struct HomeView_Previews : PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
