//
//  HostingController.swift
//  MetroTimer WatchKit Extension
//
//  Created by Jonas Frey on 07.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

// FIXME: This can't be the right way
typealias ContentViewWithEnvironment = _ModifiedContent<ContentView, _EnvironmentKeyWritingModifier<MetroHandler?>>

class HostingController : WKHostingController<ContentViewWithEnvironment> {
    override var body: ContentViewWithEnvironment {
        return ContentView().environmentObject(MetroHandler())
    }
}
