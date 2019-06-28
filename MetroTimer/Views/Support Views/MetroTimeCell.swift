//
//  MetroTimeCell.swift
//  MetroTimer
//
//  Created by Jonas Frey on 07.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct MetroTimeCell : View {
    
    var train: JFTrain
    var timeString: String
    
    var body: some View {
            HStack {
                Text("\(train.route) \(String(describing: train.destination))")
                Spacer()
                Text(timeString)
            }
    }
}

#if DEBUG
struct MetroTimeCell_Previews : PreviewProvider {
    static var previews: some View {
        MetroTimeCell(train: JFTrain(route: "5", destination: "Rintheim"), timeString: "in 5 min")
    }
}
#endif
