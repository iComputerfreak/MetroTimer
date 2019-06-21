//
//  UserDefaultsWrapper.swift
//  MetroTimer
//
//  Created by Jonas Frey on 19.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var value: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // FIXME: Add this after confirming JFFavorite to property-list
            //UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
