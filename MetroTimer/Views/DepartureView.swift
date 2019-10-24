//
//  DepartureView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 14.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI
import JFSwiftUI

struct DepartureView : View {
    
    @State private var maxInfosPerStation = [String: Int]()
    
    @ObservedObject private var metroHandler = MetroHandler.shared
    
    func viewDidAppear() {
        print("View did appear")
        // Load the maxInfosPerStation (it may be changed in the settings)
        let stored = UserDefaults.standard.dictionary(forKey: JFLiterals.Keys.maxInfosPerStation.rawValue) as? [String: Int]
        self.maxInfosPerStation = stored ?? [:]
        self.metroHandler.startUpdates()
    }
    
    func viewDidDisappear() {
        print("View did disappear")
        self.metroHandler.stopUpdates()
    }
    
    var body: some View {
        NavigationView {
            if self.metroHandler.departures.isEmpty {
                // Loading Screen
                HStack {
                    ActivityIndicator(style: .medium)
                    Text("Loading...")
                        .font(.headline)
                }
                .navigationBarTitle(Text("Departures"))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.metroHandler.stopUpdates()
                        self.metroHandler.startUpdates()
                    }) {
                        Text("Retry")
                    }
                )
            } else {
                // Actual content
                self.departuresList
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
            
            // Start updates on appear
            .onAppear(perform: viewDidAppear)
            // Stop updates on disappear
            .onDisappear(perform: viewDidDisappear)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var departuresList: some View {
        List {
            ForEach(self.metroHandler.stations.keys.sorted(), id: \.self) { stationName in
                Section(header: Text(stationName)) {
                    // Show the first x departures for each favorite
                    ForEach(self.departures(stationName), id: \.self) { (departure: JFDeparture) in
                        MetroTimeCell(train: departure.train, timeString: departure.timeString)
                    }
                }
            }
        }
    }
    
    func departures(_ stationName: String) -> [JFDeparture] {
        let maxInfos = self.maxInfosPerStation[stationName] ?? JFLiterals.maxInfosPerStation
        let departures = self.metroHandler.stations[stationName]!
        return Array(departures.prefix(maxInfos))
    }
}

#if DEBUG
struct DepartureView_Previews : PreviewProvider {
    static var previews: some View {
        DepartureView()
    }
}
#endif
