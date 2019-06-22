//
//  Station.swift
//  MetroTimer
//
//  Created by Jonas Frey on 08.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

/// Represents a station with an id, name and coordinates
struct JFStation: Identifiable, Equatable, Hashable, Codable {
    /// The stop-id used by the KVV Live API
    var id: String
    /// The name of the station
    var name: String
    /// The geographical coordinates of the station
    var coordinates: JFCoordinates
}

/// Represents a set of latitude and longitude coordinates
struct JFCoordinates: Equatable, Hashable, Codable {
    /// The latitude
    var lat: Double
    /// The longitude
    var lon: Double
}
