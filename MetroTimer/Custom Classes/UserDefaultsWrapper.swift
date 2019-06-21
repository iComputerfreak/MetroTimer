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
struct UserDefault<T> where T: Codable {
    
    let key: String
    let defaultValue: T
    let encoded: Bool
    
    init(_ key: String, defaultValue: T, encoded: Bool = false) {
        self.key = key
        self.defaultValue = defaultValue
        self.encoded = encoded
    }
    
    var value: T {
        get {
            if encoded {
                if let data = UserDefaults.standard.data(forKey: key) {
                    if let value = try? PropertyListDecoder().decode(T.self, from: data) {
                        return value
                    }
                }
                return defaultValue
            } else {
                return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            }
        }
        set {
            if encoded {
                UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}
