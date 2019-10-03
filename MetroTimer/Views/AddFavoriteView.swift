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
    @State var searchText: String = ""
    @State var searchResults: [JFStation] = []
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearchEditingChanged: {
                    guard !self.searchText.isEmpty else {
                        return
                    }
                    print("Searching for \(self.searchText)")
                    self.updateSearchResults()
                })
                List(searchResults) { station in
                    NavigationLink(destination: AddLineView()) {
                        Text(station.name)
                    }
                }
            }
        .navigationBarTitle("Station")
        }
    }
    
    
    func updateSearchResults() {
        let request = Request()
        request.searchStop(by: searchText) { (stops) in
            searchResults = stops.map { (stop) -> JFStation in
                let coordinates = JFCoordinates(lat: stop.coordinates.lat, lon: stop.coordinates.lon)
                return JFStation(id: stop.id, name: stop.name, coordinates: coordinates)
            }
        }
        print("Updated \(searchResults.count) search results")
    }
}

#if DEBUG
struct AddFavoriteView_Previews : PreviewProvider {
    static var previews: some View {
        AddFavoriteView()
    }
}
#endif
