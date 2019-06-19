//
//  JFUtils.swift
//  MetroTimer
//
//  Created by Jonas Frey on 27.05.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import KVVlive

class JFUtils {
    
    typealias Coordinate = (lat: Double, lon: Double)
    
    public static let shared = JFUtils()
    
    // Initializer disabled
    private init() {}
    
    static func distanceSquared(from: Coordinate, to: Coordinate) -> Double {
        return (from.lat - to.lat) * (from.lat - to.lat) + (from.lon - to.lon) * (from.lon - to.lon)
    }
    
}
