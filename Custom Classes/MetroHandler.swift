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
    typealias PublisherType = PassthroughSubject<Void, Never>
    var didChange = PassthroughSubject<Void, Never>()
    
    static let shared = MetroHandler()
    
    private init() {}
    
    /// The time interval in which the timer tries to update the data
    let updateInterval: TimeInterval = 30
    /// The timer that updates the departures
    var updateTimer: Timer? = nil
    
    // Load the value from the UserDefaults or use the default value
    // TODO: Remove this debug value
    //@UserDefault("favorites", defaultValue: [JFFavorite]())
    @UserDefault("favorites", defaultValue: Placeholder.favorites, encoded: true)
    var favorites: [JFFavorite] {
        didSet {
            didChange.send()
        }
    }
    
    /// The next departures for the favorites
    var departures = [JFDeparture]() {
        didSet {
            didChange.send()
        }
    }
    
    var stations: [String: [JFDeparture]] {
        .init(grouping: self.departures, by: { $0.station.name })
    }
    
    /// Starts the update timer and immediately fires the first update
    @objc func startUpdates() {
        // If already running, do nothing
        guard updateTimer == nil else {
            print("Timer already running")
            return
        }
        print("Starting updates")
        updateTimer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        updateTimer?.fire()
    }
    
    /// Stops the update timer
    @objc func stopUpdates() {
        print("Stopping updates")
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    /// Manually refreshes the departure data asyc
    @objc func refreshData() {
        DispatchQueue.main.async {
            print("Starting update")
            let request = Request()
            var departures = [JFDeparture]()
            // Get the data
            for favorite in self.favorites {
                print("Getting departures for \(favorite.station.name)")
                request.getDepartures(route: favorite.train.route, stopId: favorite.station.id) { deps in
                    // Filter out the wrong destinations
                    let favoriteDeps = deps.filter({ $0.destination == favorite.train.destination })
                    departures.append(contentsOf: favoriteDeps.map({ JFDeparture(from: $0, station: favorite.station) }))
                }
            }
            
            self.departures = departures
            print("Update finished")
        }
    }
    
}
