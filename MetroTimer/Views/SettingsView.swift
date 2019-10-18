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
    
    @ObservedObject private var metroHandler = MetroHandler.shared
    @State private var editMode: EditMode = .inactive
    
    // Adding a new station
    @State private var isAddingFavorite = false
    
    @State private var maxInfosPerStation: [String: Int] = {
        let stored = UserDefaults.standard.dictionary(forKey: JFLiterals.Keys.maxInfosPerStation.rawValue) as? [String: Int] ?? [:]
        return stored
    }()
    
    func didAppear() {
        print("Settings View did Appear")
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
                
                if !self.metroHandler.favorites.isEmpty {
                    Section(header: Text("Maximum lines to show for each station")) {
                        ForEach(self.metroHandler.favoriteStations, id: \.self) { station in
                            Stepper(value: Binding(get: {
                                // Load or use the default value
                                if let value = self.maxInfosPerStation[station.name] {
                                    return value
                                } else {
                                    // No entry available, set the default value
                                    return JFLiterals.maxInfosPerStation
                                }
                            }, set: { newValue in
                                self.maxInfosPerStation[station.name] = newValue
                            }),
                                    in: 1...10, step: 1, onEditingChanged: { _ in
                                        // Save the variable to the user defaults
                                        UserDefaults.standard.set(self.maxInfosPerStation, forKey: JFLiterals.Keys.maxInfosPerStation.rawValue)
                                    }, label: {
                                HStack {
                                    Text("\(station.name)")
                                    Spacer()
                                    Text("\(self.maxInfosPerStation[station.name] ?? JFLiterals.maxInfosPerStation)")
                                        .bold()
                                }
                            })
                        }
                    }
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
