//
//  HappeningDescriptionView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import SwiftUI

struct HappeningDescriptionView: View {
    
    // MARK: PROPERTIES
    
    let description: String
    
    // MARK: BODY
    var body: some View {
        Section {
            Text(description.hasSuffix("\n") ? String(description.dropLast(2)) : description)
                .padding(.vertical, 6)
        } header: {
            Text("Description")
                .font(.footnote)
        }
    }
}
