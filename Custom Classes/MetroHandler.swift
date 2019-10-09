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
import JFSwiftUI

class MetroHandler: ObservableObject {
    typealias PublisherType = PassthroughSubject<Void, Never>
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    private let favoritesKey = "favorites"
    
    static let shared = MetroHandler()
    let request = Request()
    
    /// The time interval in which the timer tries to update the data
    let updateInterval: TimeInterval = 30
    /// The timer that updates the departures
    var updateTimer: Timer? = nil
    
    /// The favorite (station, route, direction) tuples
    var favorites: [JFFavorite] {
        willSet {
            objectWillChange.send()
        }
        didSet {
            // Save the new favorites to the UserDefaults
            DispatchQueue.main.async {
                UserDefaults.standard.set(try? PropertyListEncoder().encode(self.favorites), forKey: self.favoritesKey)
            }
        }
    }
    
    /// The next departures for the favorites
    @Published var departures = [JFDeparture]()
    
    /// Returns a dictionary of station names with the corresponding departures of that station (sorted by time)
    var stations: [String: [JFDeparture]] {
        .init(grouping: self.departures.sorted(by: { JFUtils.compareTimeStrings($0.timeString, $1.timeString) }), by: { $0.station.name })
    }
    
    private init() {
        // Load the favorites from the UserDefaults
        self.favorites = []
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            if let value = try? PropertyListDecoder().decode([JFFavorite].self, from: data) {
                self.favorites = value
            }
        }
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
            var departures = [JFDeparture]()
            // Get the data
            for favorite in self.favorites {
                print("Getting departures for \(favorite.station.name)")
                self.request.getDepartures(route: favorite.train.route, stopId: favorite.station.id) { deps in
                    // Filter out the wrong destinations
                    let favoriteDeps = deps.filter({ $0.destination == favorite.train.destination })
                    departures.append(contentsOf: favoriteDeps.map({ JFDeparture(from: $0, station: favorite.station) }))
                }
            }
            
            self.objectWillChange.send()
            self.departures = departures
            #if DEBUG
            print("Departures: \(departures)")
            #endif
            print("Update finished")
        }
    }
    
    // Synchronically!
    func trains(at station: JFStation) -> [JFTrain] {
        let semaphore = DispatchSemaphore(value: 0)
        var trains = [JFTrain]()
        // Fetch the lines and direction by checking the next available departures
        self.request.getDepartures(stopId: station.id) { (departures) in
            for dep in departures {
                let train = JFTrain(route: dep.route, destination: dep.destination)
                if !trains.contains(train) {
                    trains.append(train)
                }
            }
            // Free the semaphore slot
            semaphore.signal()
        }
        
        semaphore.wait()
        return trains
    }
    
}
