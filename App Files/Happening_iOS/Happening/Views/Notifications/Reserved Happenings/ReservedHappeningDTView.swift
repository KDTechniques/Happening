//
//  ReservedHappeningDTView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-03.
//

import SwiftUI

struct ReservedHappeningDTView: View {
    
    // MARK: PROPERTIES
    
    let startingDT: String
    let endingDT: String
    
    // MARK: BODY
    var body: some View {
        Section {
            Text("\(startingDT) - \(endingDT)")
                .foregroundColor(.green)
        } header: {
            Text("Date & Time")
                .font(.footnote)
        }
    }
}
