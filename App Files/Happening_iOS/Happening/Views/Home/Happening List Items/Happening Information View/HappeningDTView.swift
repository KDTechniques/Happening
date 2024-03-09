//
//  HappeningDTView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import SwiftUI

struct HappeningDTView: View {
    
    // MARK: PROPERTIES
    
    let startingDT: String
    let endingDT: String
    
    // MARK: BODY
    var body: some View {
        Section {
            Text("\(startingDT) - \(endingDT)")
        } header: {
            Text("Date & Time")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
//struct HappeningDTView_Previews: PreviewProvider {
//    static var previews: some View {
//        HappeningDTView()
//    }
//}
