//
//  AddFavoriteView().swift
//  MetroTimer
//
//  Created by Jonas Frey on 21.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI
import KVVlive

struct AddFavoriteView : View {
    
    @EnvironmentObject var metroHandler: MetroHandler
    @State var searchText: String = ""
    @State var searchResults: [JFStation] = []
    
    var body: some View {
        VStack {
            // FIXME: Replace onEditingChanged: with onCommit:
            TextField($searchText, placeholder: Text("Search"), onEditingChanged: { stillEditing in
                guard !stillEditing else {
                    return
                }
                guard !self.searchText.isEmpty else {
                    return
                }
                print("Searching for \(self.searchText)")
                
                self.updateSearchResults()
            })
                .padding(5.0)
                .border(Color.black, width: 2.0, cornerRadius: 5.0)
            
            // FIXME: Add list with search results
            //List(searchResults, selection: nil, action: { print("Action") }, rowContent: { Text("Content") })
        }
        .padding()
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
