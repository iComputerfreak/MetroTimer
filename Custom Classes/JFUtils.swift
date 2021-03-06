//
//  JFUtils.swift
//  MetroTimer
//
//  Created by Jonas Frey on 27.05.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation

/// A set of utility functions
struct JFUtils {
    
    /// Singleton instance property
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
    
    /// Compares two time strings and returns, whether the first is lower than or equal to the second.
    /// - Parameters:
    ///   - timeString1: The first time string
    ///   - timeString2: The second time string
    static func compareTimeStrings(_ timeString1: String, _ timeString2: String) -> Bool {
        if timeString1 == "now" {
            return true
        }
        if timeString2 == "now" {
            return false
        }
        // Case 1: "x min"
        if timeString1.hasSuffix("min") {
            if timeString2.hasSuffix("min") {
                // Parse the minutes and compare
                // In case of format error return true
                return (timeStringMinutes(timeString1) ?? Int.min) <= (timeStringMinutes(timeString2) ?? Int.max)
            } else {
                return true
            }
            // Case 2: "xx:xx"
        } else {
            if timeString2.hasSuffix("min") {
                return false
            } else {
                // Parse the times and compare
                if let time1 = timeStringComponents(timeString1), let time2 = timeStringComponents(timeString2) {
                    return (time1.0 * 100 + time1.1) <= (time2.0 * 100 + time2.1)
                }
            }
        }
        return true
    }
    
    /// Extracts the minutes of a given time string.
    /// - Parameter timeString: The time string in the format `_ min`
    /// - Returns: The minutes of the given time string, or nil, if the time string is not correctly formatted
    private static func timeStringMinutes(_ timeString: String) -> Int? {
        let components = timeString.components(separatedBy: " ")
        guard components.count == 2, components.last! == "min" else {
            return nil
        }
        return Int(components.first!)
    }
    
    /// Separates a given time string into its integer components.
    /// - Parameter timeString: The time string in the format `__:__`
    /// - Returns: The hours and minutes of the time string, or nil, if the time string is not correctly formatted
    private static func timeStringComponents(_ timeString: String) -> (Int, Int)? {
        let components = timeString.components(separatedBy: ":")
        guard components.count == 2 else {
            return nil
        }
        if let hours = Int(components.first!), let mins = Int(components.last!) {
            return (hours, mins)
        }
        return nil
    }
    
}

struct JFLiterals {
    /// The default value of entries to show per station
    static let maxInfosPerStation = 3
    
    /// Keys to use for UserDefaults
    enum Keys: String {
        case maxInfosPerStation = "maxInfosPerStation"
    }
    
}

#if DEBUG

/// Represents some sample data to use for testing
struct Placeholder {
    
    static let train1 = JFTrain(route: "5", destination: "Rintheim")
    static let train2 = JFTrain(route: "5", destination: "Rheinhafen")
    
    static let durlacherTor = JFStation(id: "de:8212:3", name: "Karlsruhe Durlacher Tor", coordinates: .init(lat: 49.009255, lon: 8.413622))
    static let ottoSachs = JFStation(id: "de:8212:508", name: "Karlsruhe Otto-Sachs-Str.", coordinates: .init(lat: 49.00345241, lon: 8.38932404))
    static let kronenplatz = JFStation(id: "de:8212:80", name: "Karlsruhe Kronenplatz (Erler-Str)", coordinates: .init(lat: 49.00892899, lon: 8.41014331))
    static let rintheimForststrasse = JFStation(id: "de:8212:313", name: "Rintheim Forststraße", coordinates: .init(lat: 49.014115279999999, lon: 8.4422622))
    static let hirtenweg = JFStation(id: "de:8212:403", name: "Karlsruhe Hirtenweg/Techn.park", coordinates: .init(lat: 49.01771743, lon: 8.43965173))
    static let kronenplatzKaiserstrasse = JFStation(id: "de:8212:2", name: "Karlsruhe Kronenplatz (Kaiserstr)", coordinates: .init(lat: 49.0093644, lon: 8.40912665))
    
    static let placeholderDepartures = [
        JFDeparture(train: train1, station: ottoSachs, timeString: "in 5 min"),
        
        JFDeparture(train: train1, station: kronenplatz, timeString: "14:03"),
        JFDeparture(train: train2, station: kronenplatz, timeString: "14:13"),
        
        JFDeparture(train: train1, station: ottoSachs, timeString: "in 9 min"),
        
        JFDeparture(train: train2, station: durlacherTor, timeString: "in 1 min"),
        JFDeparture(train: train2, station: durlacherTor, timeString: "in 7 min")
    ]
    
    static let favorites: [JFFavorite] = [
        JFFavorite(station: durlacherTor, train: .init(route: "4", destination: "Waldstadt")),
        JFFavorite(station: durlacherTor, train: .init(route: "5", destination: "Rintheim")),
        JFFavorite(station: durlacherTor, train: .init(route: "S2", destination: "Reitschulschlag")),
        JFFavorite(station: rintheimForststrasse, train: .init(route: "5", destination: "Rheinhafen")),
        JFFavorite(station: hirtenweg, train: .init(route: "4", destination: "Tivoli über Hbf")),
        JFFavorite(station: hirtenweg, train: .init(route: "S2", destination: "Rheinstetten")),
        JFFavorite(station: kronenplatzKaiserstrasse, train: .init(route: "5", destination: "Rintheim")),
        JFFavorite(station: kronenplatzKaiserstrasse, train: .init(route: "S2", destination: "Blankenloch")),
        JFFavorite(station: kronenplatzKaiserstrasse, train: .init(route: "4", destination: "Waldstadt"))
    ]
    
}

#endif
