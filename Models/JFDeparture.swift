//
//  JFDeparture.swift
//  MetroTimer
//
//  Created by Jonas Frey on 08.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import KVVlive

/// Represents a departure of a train at a specific station at a given time
struct JFDeparture: Equatable, Hashable {
    var train: JFTrain
    var station: JFStation
    /// The time in a human readable format
    ///
    /// - Examples:
    ///
    ///    "7 min"
    ///    "15:30"
    var timeString: String
    
    /// Creates a new departure
    /// - Parameters:
    ///   - train: The train that departs
    ///   - station: The station, the train departs from
    ///   - timeString: A human readable time string representing the departure time
    init(train: JFTrain, station: JFStation, timeString: String) {
        self.train = train
        self.station = station
        if timeString == "0" {
            self.timeString = "now"
        } else {
            self.timeString = timeString
        }
    }
    
    /// Creates a new JFDeparture from a Departure
    /// - Parameters:
    ///   - from: The Departure to use
    ///   - station: The station where the train departs
    init(from departure: Departure, station: JFStation) {
        self.init(train: JFTrain(route: departure.route, destination: departure.destination), station: station, timeString: departure.time)
    }
}
