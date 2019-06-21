//
//  DepartureView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 14.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct DepartureView : View {
    
    @EnvironmentObject private var metroHandler: MetroHandler
    
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
            // Start updates on appear
            .onAppear {
                self.metroHandler.startUpdates()
            }
            // Stop updates on disappear
            .onDisappear {
                self.metroHandler.stopUpdates()
            }
    }
}

#if DEBUG
struct DepartureView_Previews : PreviewProvider {
    static var previews: some View {
        DepartureView().environmentObject(MetroHandler())
    }
}
#endif


#if DEBUG

/// Represents some sample data
struct Placeholder {
    
    static let train1 = JFTrain(route: "5", destination: "Rintheim")
    static let train2 = JFTrain(route: "5", destination: "Rheinhafen")
    
    static let durlacherTor = JFStation(id: "de:8212:3", name: "Karlsruhe Durlacher Tor", coordinates: .init(lat: 49.009255, lon: 8.413622))
    static let ottoSachs = JFStation(id: "de:8212:508", name: "Karlsruhe Otto-Sachs-Str.", coordinates: .init(lat: 49.00345241, lon: 8.38932404))
    static let kronenplatz = JFStation(id: "de:8212:80", name: "Karlsruhe Kronenplatz (Erler-Str)", coordinates: .init(lat: 49.00892899, lon: 8.41014331))
    
    static let placeholderDepartures = [
        JFDeparture(train: train1, station: ottoSachs, timeString: "in 5 min"),
        
        JFDeparture(train: train1, station: kronenplatz, timeString: "14:03"),
        JFDeparture(train: train2, station: kronenplatz, timeString: "14:13"),
        
        JFDeparture(train: train1, station: ottoSachs, timeString: "in 9 min"),
        
        JFDeparture(train: train2, station: durlacherTor, timeString: "in 1 min"),
        JFDeparture(train: train2, station: durlacherTor, timeString: "in 7 min")
    ]
    
    static let favorites: [JFFavorite] = [
        JFFavorite(station: ottoSachs, train: train1),
        JFFavorite(station: durlacherTor, train: train2),
        JFFavorite(station: kronenplatz, train: train2)
    ]
    
}

#endif
