//
//  MyHappeningPhoneNoView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI

struct MyHappeningPhoneNoView: View {
    
    // MARK: PROPERTIES
    
    let phoneNo: String
    
    // MARK: BODY
    var body: some View {
        Section {
            Text(phoneNo)
        } header: {
            Text("Contact Number")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct MyHappeningPhoneNoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                MyHappeningPhoneNoView(phoneNo: "0770050165")
            }
            .preferredColorScheme(.dark)
            
            List {
                MyHappeningPhoneNoView(phoneNo: "0770050165")
            }
        }
        .listStyle(.grouped)
    }
}
