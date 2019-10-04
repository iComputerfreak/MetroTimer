//
//  AddLineView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 03.10.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI
import JFSwiftUI

struct AddLineView: View {
    
    var station: JFStation
    @State private var route: String?
    @State private var destination: String?
    @State private var trains: [JFTrain]?
    private var routes: [String]? {
        if let trains = self.trains {
            return Array(Set(trains.map({ $0.route })))
        }
        return nil
    }
    let testRoutes = ["1", "2", "S4"]
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var metroHandler = MetroHandler.shared
    
    func didAppear() {
        print("Loading trains...")
        // Load the routes and destinations
        DispatchQueue.main.async {
            self.trains = self.metroHandler.trains(at: self.station)
            print("Trains loaded!")
        }
    }
    
    var body: some View {
        LoadingScreen(isLoading: (self.trains == nil)) {
            Form {
                //Section {
                    Text("\(self.route ?? "nil")")
                    Picker("Route", selection: self.$route) {
                        ForEach(self.routes ?? [], id: \.self) { route in
                            Text(route).tag(route)
                        }
                    }
                        .pickerStyle(WheelPickerStyle())
                    if route != nil {
                        Picker("Destination", selection: $destination) {
                            ForEach(directions(route: self.route) ?? [], id: \.self) { destination in
                                Text(destination)
                            }
                        }
                    }
                //}
            }
                .navigationBarItems(trailing: Button("Add") {
                    // TODO: Dismiss previous sheet too!
                    print("Route: \(self.route ?? "nil"), Destination: \(self.destination ?? "nil")")
                    self.presentationMode.wrappedValue.dismiss()
                })
        }
        .onAppear(perform: self.didAppear)
        .navigationBarTitle("Route and Direction")
    }
    
    private func directions(route: String?) -> [String]? {
        if route == nil {
            return nil
        }
        if let trains = self.trains {
            return Array(Set(
                // Get the destination of all trains that have the specified route
                trains.filter({ $0.route == route }).map({ $0.destination })
            ))
        }
        return nil
    }
}

struct AddLineView_Previews: PreviewProvider {
    static var previews: some View {
        //AddLineView()
        Text("Not available")
    }
}
