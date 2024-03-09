//
//  ReservedHappeningSpaceFeeView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-03.
//

import SwiftUI

struct ReservedHappeningSpaceFeeView: View {
    
    // MARK: PROPERTIES
    
    let spaceFee: String
    
    // MARK: BODY
    var body: some View {
        Section {
            Text(spaceFee)
        } header: {
            Text("Space Fee")
                .font(.footnote)
        } footer: {
            Text(spaceFee.contains("Free") ? "You can participate for free of charge." : "You have already paid \(spaceFee).")
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
            
        }
    }
}
