//
//  AddLineView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 03.10.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct AddLineView: View {
    var body: some View {
        NavigationView {
            
            Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
            
            .navigationBarTitle("Line")
                .navigationBarItems(trailing: Button("Add") {
                    
                })
        }
    }
}

struct AddLineView_Previews: PreviewProvider {
    static var previews: some View {
        AddLineView()
    }
}
