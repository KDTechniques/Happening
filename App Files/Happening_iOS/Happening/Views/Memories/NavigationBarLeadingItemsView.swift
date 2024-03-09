//
//  NavigationBarLeadingItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct NavigationBarLeadingItemsView: View {
    
    // MARK: PROPERTIES
    
    
    // MARK: BODY
    var body: some View {
        Button("Privacy") {
            // code here
        }
    }
}

// MARK: PREVIEWS
struct NavigationBarLeadingItems_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                HStack {
                    NavigationBarLeadingItemsView()
                        .preferredColorScheme(.dark)
                        .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                HStack {
                    NavigationBarLeadingItemsView()
                        .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
