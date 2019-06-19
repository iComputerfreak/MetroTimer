//
//  JFDeparture.swift
//  MetroTimer
//
//  Created by Jonas Frey on 08.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import KVVlive

struct JFDeparture: Equatable, Hashable {
    var train: JFTrain
    var station: JFStation
    var timeString: String
    
    init(train: JFTrain, station: JFStation, timeString: String) {
        self.train = train
        self.station = station
        self.timeString = timeString
    }
    
    init(from departure: Departure, station: JFStation) {
        self.init(train: JFTrain(route: departure.route, destination: departure.destination), station: station, timeString: departure.time)
    }
}
