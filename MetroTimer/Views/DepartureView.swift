//
//  DepartureView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 14.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct DepartureView : View {
    
    @ObjectBinding var metroHandler: MetroHandler
    
    var stations: [String: [JFDeparture]] {
        .init(grouping: metroHandler.departures,
              by: { $0.station.name })
    }
    
    var body: some View {
        NavigationView {
            List {
                // Create a section for every station
                ForEach(stations.keys.sorted().identified(by: \.self)) { stationName in
                    Section(header: Text(stationName)) {
                        // Show the first three departures for each station
                        ForEach(self.stations[stationName]!.prefix(3).identified(by: \.self)) { (departure: JFDeparture) in
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
    }
}

#if DEBUG
struct DepartureView_Previews : PreviewProvider {
    static var previews: some View {
        DepartureView(metroHandler: MetroHandler())
    }
}
#endif
