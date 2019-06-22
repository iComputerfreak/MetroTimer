//
//  Train.swift
//  MetroTimer
//
//  Created by Jonas Frey on 08.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

/// Represents a train with a route number and destination
struct JFTrain: Equatable, Hashable, Codable {
    /// The route number
    var route: String
    /// The destination station name of the train
    var destination: String
}
