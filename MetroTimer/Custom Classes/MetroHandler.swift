//
//  MetroHandler.swift
//  MetroTimer
//
//  Created by Jonas Frey on 08.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI
import KVVlive
import Combine

class MetroHandler: BindableObject {
    typealias PublisherType = PassthroughSubject<[JFDeparture], Never>
    var didChange = PassthroughSubject<[JFDeparture], Never>()
    
    /// The time interval in which the timer tries to update the data
    let updateInterval: TimeInterval = 30
    /// The timer that updates the departures
    var updateTimer: Timer? = nil
    
    // Load the value from the UserDefaults or use the default value
    // TODO: Remove this debug value
    //@UserDefault("favorites", defaultValue: [JFFavorite]())
    @UserDefault("favorites", defaultValue: Placeholder.favorites)
    var favorites: [JFFavorite]
    
    var departures = [JFDeparture]() {
        didSet {
            didChange.send(self.departures)
        }
    }
    
    /// Starts the update timer and immediately fires the first update
    func startUpdates() {
        updateTimer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        updateTimer?.fire()
    }
    
    func stopUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    @objc func refreshData() {
        let request = Request()
        var departures = [JFDeparture]()
        // Get the data
        departures = []//Placeholder.placeholderDepartures
        
        for favorite in favorites {
            print("Getting departures for \(favorite.station.name)")
            request.getDepartures(route: favorite.train.route, stopId: favorite.station.id) { deps in
                print("Received departures: \(deps)")
                let favoriteDeps = deps.filter({ $0.destination.hashValue == favorite.train.destination.hashValue })
                departures.append(contentsOf: favoriteDeps.map({ JFDeparture(from: $0, station: favorite.station) }))
            }
            print("Going to the next favorite...")
        }
        
        self.departures = departures
    }
    
}

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
        (ottoSachs, train1),
        (durlacherTor, train2),
        (kronenplatz, train2)
    ]
    
}
