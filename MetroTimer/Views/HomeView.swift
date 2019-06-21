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
        
        TabbedView {
            DepartureView()
                .tag(0)
                // FIXME: Add text
                .tabItemLabel(Text("Departures"))
                //.tabItemLabel(Image(systemName: "clock"))
                /*.tabItemLabel {
                    Image(systemName: "clock")
                    Text("Departures")
                }*/
            
            SettingsView()
                .tag(1)
                // FIXME: Add text
                .tabItemLabel(Text("Settings"))
                //.tabItemLabel(Image(systemName: "gear"))
                /*.tabItemLabel {
                    Image(systemName: "gear")
                    Text("Settings")
                }*/
        }
    }
}

#if DEBUG
struct HomeView_Previews : PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(MetroHandler())
    }
}
#endif
