//
//  JFUtils.swift
//  MetroTimer
//
//  Created by Jonas Frey on 27.05.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation

/// A set of utility functions
class JFUtils {
    
    public static let shared = JFUtils()
    
    // Initializer disabled
    private init() {}
    
    /// Calculates the distance of two coordinates by the power of 2
    /// - Parameters:
    ///   - from: Position 1
    ///   - to: Position 2
    /// - Returns: The distance of the two points by the power of two
    static func distanceSquared(from: JFCoordinates, to: JFCoordinates) -> Double {
        return (from.lat - to.lat) * (from.lat - to.lat) + (from.lon - to.lon) * (from.lon - to.lon)
    }
    
    /// Calculates the distance of two coordinates
    /// - Parameters:
    ///   - from: Position 1
    ///   - to: Position 2
    /// - Returns: The distance of the two points
    static func distance(from: JFCoordinates, to: JFCoordinates) -> Double {
        return sqrt(distanceSquared(from: from, to: to))
    }
    
}

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
