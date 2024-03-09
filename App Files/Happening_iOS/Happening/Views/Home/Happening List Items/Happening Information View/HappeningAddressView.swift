//
//  HappeningAddressView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import SwiftUI

struct HappeningAddressView: View {
    
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
//struct HappeningAddressView_Previews: PreviewProvider {
//    static var previews: some View {
//        HappeningAddressView()
//    }
//}
