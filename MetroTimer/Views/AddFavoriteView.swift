//
//  AddFavoriteView().swift
//  MetroTimer
//
//  Created by Jonas Frey on 21.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI
import KVVlive
import JFSwiftUI

struct AddFavoriteView : View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var searchResults: [JFStation]? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearchButtonClicked: {
                    guard !self.searchText.isEmpty else {
                        return
                    }
                    print("Searching for \(self.searchText)")
                    self.updateSearchResults()
                })
                // searchResults == nil means not yet searched!
                if searchResults != nil && searchResults!.isEmpty && !searchText.isEmpty {
                    List {
                        HStack {
                            Spacer()
                            Text("No results")
                            Spacer()
                        }
                    }
                } else {
                    List(searchResults ?? []) { station in
                        NavigationLink(destination: AddLineView(station: station, superPresentationMode: self.presentationMode)) {
                            Text(station.name)
                        }.isDetailLink(false)
                    }
                }
            }
            .navigationBarTitle("Station")
            .navigationBarItems(trailing: Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    func updateSearchResults() {
        let request = Request()
        print("Searching for \(searchText)")
        request.searchStop(by: searchText) { (stops) in
            searchResults = stops.map { (stop) -> JFStation in
                let coordinates = JFCoordinates(lat: stop.coordinates.lat, lon: stop.coordinates.lon)
                return JFStation(id: stop.id, name: stop.name, coordinates: coordinates)
            }
        }
        print("Updated \(searchResults?.count ?? -1) search results")
    }
}

#if DEBUG
struct AddFavoriteView_Previews : PreviewProvider {
    static var previews: some View {
        Text("Not implemented yet")
        //AddFavoriteView()
    }
}
#endif
