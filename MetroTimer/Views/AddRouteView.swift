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
    @State private var route: String = ""
    @State private var destination: String = ""
    @State private var trains: [JFTrain]?
    @Binding var superPresentationMode: PresentationMode
    
    private var routes: [String]? {
        if let trains = self.trains {
            return Array(Set(trains.map({ $0.route }))).sorted()
        }
        return nil
    }
    
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
                Section {
                    Picker("Route", selection: self.$route) {
                        // Type of route specified to boost building
                        ForEach(self.routes ?? [], id: \.self) { (route: String) in
                            Text(route)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    if !route.isEmpty {
                        Picker("Destination", selection: $destination) {
                            // Type of destination specified to boost building
                            ForEach(directions(route: self.route) ?? [], id: \.self) { (destination: String) in
                                Text(destination)
                            }
                        }
                            // Change to SegmentedPickerStyle, when its fixed (currently it shows an extra item from the last state)
                            //.pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
                .navigationBarItems(trailing: Button("Add") {
                    print("Route: \(self.route), Destination: \(self.destination)")
                    self.metroHandler.favorites.append(JFFavorite(station: self.station, train: JFTrain(route: self.route, destination: self.destination)))
                    self.superPresentationMode.dismiss()
                })
        }
        .onAppear(perform: self.didAppear)
        .navigationBarTitle("Route and Direction")
    }
    
    private func directions(route: String) -> [String]? {
        if route.isEmpty {
            return nil
        }
        if let trains = self.trains {
            return Array(Set(
                // Get the destination of all trains that have the specified route
                trains.filter({ $0.route == route }).map({ $0.destination })
                )).sorted()
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
