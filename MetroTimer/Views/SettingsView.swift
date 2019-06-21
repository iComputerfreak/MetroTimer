//
//  SettingsView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 14.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct SettingsView : View {
    
    @EnvironmentObject private var metroHandler: MetroHandler
    @State var draftFavorites: [JFFavorite] = Placeholder.favorites
    
    init() {
        print("Initialized")
        self.draftFavorites = metroHandler.favorites
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Favorites")) {
                    ForEach(self.draftFavorites.identified(by: \.self)) { (favorite: JFFavorite) in
                        FavoriteCell(favorite: favorite)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach({ i in
                            self.draftFavorites.remove(at: i)
                        })
                    }
                    .onMove { (source, destination) in
                        // sort the indexes high to low
                        let reversedSource = source.sorted().reversed()
                        
                        for index in reversedSource {
                            // for each item, remove it and insert it at the destination
                            self.draftFavorites.insert(self.draftFavorites.remove(at: index), at: destination)
                        }
                    }
                }
            }
            
            .navigationBarItems(trailing: EditButton())
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
        }
    }
    
    struct FavoriteCell: View {
        var favorite: JFFavorite
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(favorite.train.route)
                            .bold()
                        Text(favorite.train.destination)
                    }
                    Text(favorite.station.name)
                        .font(.footnote)
                }
            }
        }
    }
}

#if DEBUG
struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
