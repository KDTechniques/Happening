//
//  MyHappeningSpaceFeeView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI

struct MyHappeningSpaceFeeView: View {
    
    // MARK: PROPERTIES
    
    let spaceFee: String
    
    // MARK: BODY
    var body: some View {
        Section {
            Text(spaceFee)
        } header: {
            Text("Space Fee")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct MyHappeningSpaceFeeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                MyHappeningSpaceFeeView(spaceFee: "1000 LKR")
            }
            .preferredColorScheme(.dark)
            
            List {
                MyHappeningSpaceFeeView(spaceFee: "1000 LKR")
            }
        }
        .listStyle(.grouped)
    }
}
