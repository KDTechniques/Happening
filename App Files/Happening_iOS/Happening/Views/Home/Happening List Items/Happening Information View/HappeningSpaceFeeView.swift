//
//  HappeningSpaceFeeView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import SwiftUI

struct HappeningSpaceFeeView: View {
    
    // MARK: PROPERTIES
    
    let spaceFee: String
    let isFollowing: Bool
    let userName: String
    
    // MARK: BODY
    var body: some View {
        Section {
            Text(spaceFee)
                .foregroundColor(.green)
        } header: {
            Text("Space Fee")
                .font(.footnote)
        } footer: {
            if isFollowing {
                Text(spaceFee.contains("Free") ? "You can participate for free of charge." : "You will be charged \(spaceFee).")
                    .font(.footnote)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("To make a reservation, you may need to follow \(userName).")
                    .font(.footnote)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
