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
    
    @UserDefault(JFLiterals.Keys.maxInfosPerStation.rawValue, defaultValue: 3)
    var maxInfosPerSection: Int
    
    @State private var metroHandler = MetroHandler.shared
    
    func viewDidAppear() {
        self.metroHandler.startUpdates()
    }
    
    func viewDidDisappear() {
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
    }
    
    var departuresList: some View {
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
    }
}

#if DEBUG
struct DepartureView_Previews : PreviewProvider {
    static var previews: some View {
        DepartureView()
    }
}
#endif
