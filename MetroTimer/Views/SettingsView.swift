//
//  SettingsView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 14.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView : View {
    
    @State private var metroHandler = MetroHandler.shared
    @State private var editMode: EditMode = .inactive
    
    @State private var isAddingFavorite = false
    
    @State private var maxInfosPerStation: Int = {
        let stored = UserDefaults.standard.integer(forKey: JFLiterals.Keys.maxInfosPerStation.rawValue)
        return stored > 0 ? stored : JFLiterals.maxInfosPerStation
    }()
    
    func didAppear() {
        
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Favorites")) {
                    ForEach(self.metroHandler.favorites, id: \.self) { (favorite: JFFavorite) in
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
                    
                    Button(action: {
                        self.isAddingFavorite = true
                    }, label: {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle")
                            Text("Add Favorite")
                            Spacer()
                        }.foregroundColor(.blue)
                    })
                    
                }
                
                Section(header: Text("Maximum lines to show per station")) {
                    Stepper(value: $maxInfosPerStation, in: 1...10, step: 1, onEditingChanged: { _ in
                        UserDefaults.standard.set(self.maxInfosPerStation, forKey: JFLiterals.Keys.maxInfosPerStation.rawValue)
                    }, label: {
                        Text("Entries per Station: \(self.maxInfosPerStation)")
                    })
                }
            }
                
            .navigationBarItems(trailing: EditButton())
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .environment(\.editMode, $editMode)
        }
            
        .sheet(isPresented: $isAddingFavorite) {
            AddFavoriteView()
        }
            
            // When the SettingsView appears
            .onAppear(perform: self.didAppear)
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
