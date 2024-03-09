//
//  MyHappeningDescriptionView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI

struct MyHappeningDescriptionView: View {
    
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

// MARK: PREVIEWS
struct MyHappeningDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                MyHappeningDescriptionView(
                    description: "kfjogrehifbksvdnacldqfeogjrn\njefiwhgdknsvmlqfkojehgrwbknsvdclq\njhie"
                )
            }
            .preferredColorScheme(.dark)
            
            List {
                MyHappeningDescriptionView(
                    description: "kfjogrehifbksvdnacldqfeogjrn\njefiwhgdknsvmlqfkojehgrwbknsvdclq\njhie"
                )
            }
        }
        .listStyle(.grouped)
    }
}
