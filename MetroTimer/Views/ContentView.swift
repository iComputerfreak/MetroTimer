//
//  ContentView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 07.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView : View {
    
    var body: some View {
        
        TabbedView {
            DepartureView(metroHandler: MetroHandler())
                .tag(0)
                // FIXME: Add text
                .tabItemLabel(Image(systemName: "clock"))
            
            SettingsView()
                .tag(1)
                // FIXME: Add text
                .tabItemLabel(Image(systemName: "gear"))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
