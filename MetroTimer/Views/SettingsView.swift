//
//  SettingsView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 14.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct SettingsView : View {
    
    let metroHandler = MetroHandler.shared
    @Environment(\.editMode) var mode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Favorites")) {
                    ForEach(self.metroHandler.favorites.identified(by: \.self)) { (favorite: JFFavorite) in
                        FavoriteCell(favorite: favorite)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach({ i in
                            self.metroHandler.favorites.remove(at: i)
                        })
                    }
                    // FIXME: After pressing Done, the sorting order reverts
                    .onMove { (source, destination) in
                        // sort the indexes high to low
                        let reversedSource = source.sorted().reversed()
                        
                        for index in reversedSource {
                            // for each item, remove it and insert it at the destination
                            self.metroHandler.favorites.insert(self.metroHandler.favorites.remove(at: index), at: destination)
                        }
                    }
                    
                    // FIXME: Currently editMode cannot be read inside Forms/Lists!
                    //if mode!.value != .inactive {
                    NavigationButton(destination: AddFavoriteView(), isDetail: true) {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle")
                            Text("Add Favorite")
                            Spacer()
                        }
                    }
                    //}
                }
            }
            
                .navigationBarItems(trailing: EditButton())
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
        }
        
            // When the SettingsView appears
            .onAppear {
                print("Appearing")
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
