//
//  TestView.swift
//  MetroTimer
//
//  Created by Jonas Frey on 20.06.19.
//  Copyright © 2019 Jonas Frey. All rights reserved.
//

import SwiftUI

struct TestView : View {
    
    @Environment(\.editMode) var mode
    @State var test = "Test"
    @State var test2 = "Test2"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.value == .active {
                    Button(action: {
                        self.test = "Test 2"
                        self.mode?.animation().value = .inactive
                    }) {
                        Text("Done")
                    }
                }
                
                Spacer()
                
                EditButton()
                Button(action: { self.test += "0" }) {
                    Text("Update")
                }
            }
            if self.mode?.value == .inactive {
                Text("Not Editing")
                TextView(text: $test)
            } else {
                Text("Editing")
                TextView(text: $test2)
            }
            }
            .padding()
    }
}

struct TextView: View {
    @Binding var text: String
    
    var body: some View {
        Text(text)
    }
}

#if DEBUG
struct TestView_Previews : PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
#endif
