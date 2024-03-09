//
//  MyHappeningAddressView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI

struct MyHappeningAddressView: View {
    
    // MARK: PROPERTIES
    
    let address: String
    
    // MARK: BODY
    var body: some View {
        Section {
            Text(address)
        } header: {
            Text("Address")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct MyHappeningAddressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningAddressView(address: "No.65, Mangala Rd, 3rd Kurana, Negombo.")
            }
            .preferredColorScheme(.dark)
            
            List {
                HappeningAddressView(address: "No.65, Mangala Rd, 3rd Kurana, Negombo.")
            }
        }
        .listStyle(.grouped)
    }
}
