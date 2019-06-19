//
//  MetroManager.swift
//  MetroTimer
//
//  Created by Jonas Frey on 27.05.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import KVVlive
import CoreLocation

class MetroManager: NSObject, CLLocationManagerDelegate {
    
    typealias FavoriteStop = (stop: Stop, route: String, direction: Int)
    typealias Hook = () -> Void
    
    let locationManager = CLLocationManager()
    
    var updateHook: Hook?
    
    /// Update every 30 seconds
    let updateInterval: TimeInterval = 30
    var updateTimer: Timer?
    /// A list of stop ids of the favorite stops
    let favorites: [FavoriteStop]
    var myLocation: CLLocationCoordinate2D?
    /// A list of the departure times
    public private(set) var departures = [String: [Departure]]()
    
    override init() {
        favorites = JFUtils.shared.loadFavorites()
        super.init()
        
        update()
        startUpdates()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    public func startUpdates() {
        updateTimer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    public func stopUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    @objc public func update() {
        self.departures = [:]
        let request = Request()
        
        for favorite in favorites {
            // IMPORTANT: This closure is synchronous
            request.getDepartures(route: favorite.route, stopId: favorite.stop.id) { (departures) in
                // Filter out the departures in the wrong direction
                let departures = departures.filter({ (dep) -> Bool in
                    return dep.direction == favorite.direction
                })
                self.departures[favorite.stop.id] = departures
            }
        }
        
        // If there were favorites, there should always be a result
        if !favorites.isEmpty {
            assert(!departures.isEmpty)
        }
        
        #if false
        print("Updated the departures:")
        for stopID in departures.keys {
            print("StopID: " + stopID)
            for dep in departures[stopID]! {
                print("  " + dep.description)
            }
        }
        #endif
        
        // Finished updating. Call the update hook
        if let updateHook = updateHook {
            updateHook()
        }
    }
    
    public func getDepartures(forStopID stopID: String) -> [Departure] {
        var departures = [Departure]()
        Request().getDepartures(stopId: stopID) { (deps) in
            departures = deps
        }
        return departures
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        myLocation = locValue
    }
    
    public func getNearestStop(stops: [Stop]) -> Stop? {
        guard let myLocation = myLocation else {
            return nil
        }
        
        let coords = (myLocation.latitude, myLocation.longitude)
        var nearest: (Stop, Double)?
        for stop in stops {
            let distance = JFUtils.distanceSquared(from: coords, to: stop.coordinates)
            if distance < (nearest?.1 ?? Double.infinity) {
                nearest = (stop, distance)
            }
        }
        return nearest?.0
    }
    
    
}
