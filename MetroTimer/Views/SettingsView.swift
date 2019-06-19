//
//  SettingsView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 14.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct SettingsView : View {
    var body: some View {
        NavigationView {
            List {
                Text("Setting 1")
                Text("Setting 2")
                Text("Setting 3")
            }
        }
        .navigationBarTitle(Text("Settings"))
    }
}

#if DEBUG
struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
