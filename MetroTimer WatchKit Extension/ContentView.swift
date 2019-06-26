//
//  ContentView.swift
//  MetroTimer WatchKit Extension
//
//  Created by Jonas Frey on 07.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    let maxInfosPerSection = 2
    
    let metroHandler = MetroHandler.shared
    
    func viewDidAppear() {
        metroHandler.startUpdates()
    }
    
    func viewDidDisappear() {
        metroHandler.stopUpdates()
    }
    
    var body: some View {
        List {
            // Create a section for every station
            ForEach(metroHandler.stations.keys.sorted().identified(by: \.self)) { stationName in
                Section(header: Text(stationName)) {
                    // Show the first three departures for each station
                    ForEach(self.metroHandler.stations[stationName]!.prefix(self.maxInfosPerSection).identified(by: \.self)) { (departure: JFDeparture) in
                        Text(departure.train.destination) //MetroTimeCell(train: departure.train, timeString: departure.timeString)
                    }
                }
            }
        }
        .onAppear(perform: viewDidAppear)
        .onDisappear(perform: viewDidDisappear)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
