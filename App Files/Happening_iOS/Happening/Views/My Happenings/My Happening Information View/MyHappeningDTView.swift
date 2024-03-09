//
//  MyHappeningDTView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI

struct MyHappeningDTView: View {
    
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

// MARK: PREVIEWS
struct MyHappeningDTView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                HappeningDTView(
                    startingDT: "Thu 23 Jun @ 9:00 AM",
                    endingDT: "2:00 PM"
                )
            }
            .preferredColorScheme(.dark)
            
            List {
                HappeningDTView(
                    startingDT: "Thu 23 Jun @ 9:00 AM",
                    endingDT: "2:00 PM"
                )
            }
        }
        .listStyle(.grouped)
    }
}
