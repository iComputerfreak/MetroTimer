//
//  DepartureView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 14.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct DepartureView : View {
    
    let maxInfosPerSection = 3
    
    let metroHandler = MetroHandler.shared
    
    func viewDidAppear() {
        self.metroHandler.startUpdates()
    }
    
    func viewDidDisappear() {
        self.metroHandler.stopUpdates()
    }
    
    var body: some View {
        NavigationView {
            List {
                // Create a section for every station
                ForEach(self.metroHandler.stations.keys.sorted().identified(by: \.self)) { stationName in
                    Section(header: Text(stationName)) {
                        // Show the first three departures for each station
                        ForEach(self.metroHandler.stations[stationName]!.prefix(self.maxInfosPerSection).identified(by: \.self)) { (departure: JFDeparture) in
                            MetroTimeCell(train: departure.train, timeString: departure.timeString)
                        }
                    }
                }
            }
                
                .navigationBarTitle(Text("Departures"))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.metroHandler.refreshData()
                    }) {
                        Text("Refresh")
                    }
            )
        }
            // Start updates on appear
            .onAppear(perform: viewDidAppear)
            // Stop updates on disappear
            .onDisappear(perform: viewDidDisappear)
    }
}

#if DEBUG
struct DepartureView_Previews : PreviewProvider {
    static var previews: some View {
        DepartureView()
    }
}
#endif
