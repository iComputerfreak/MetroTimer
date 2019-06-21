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
