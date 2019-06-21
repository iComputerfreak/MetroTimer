//
//  JFFavorite.swift
//  MetroTimer
//
//  Created by Jonas Frey on 19.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

/// Represents a favorite train departing from a specific station
struct JFFavorite: Hashable, Codable {
    /// The station where the train departs
    let station: JFStation
    /// The train including the direction
    let train: JFTrain
    
}
