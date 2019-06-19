//
//  Station.swift
//  MetroTimer
//
//  Created by Jonas Frey on 08.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

struct JFStation: Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var coordinates: JFCoordinates
}

struct JFCoordinates: Equatable, Hashable {
    var lat: Double
    var lon: Double
}
