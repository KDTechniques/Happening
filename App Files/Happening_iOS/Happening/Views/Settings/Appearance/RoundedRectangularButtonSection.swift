//
//  RoundedRectangularButtonSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-05.
//

import SwiftUI

struct RoundedRectangularButtonSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    
    // MARK: BODY
    var body: some View {
        Section {
            VStack {
                ButtonView(name: "Button", padding: 20) { }
            }
            .padding(.vertical, 5)
        } header: {
            Text("Sample Rectangular Button")
                .font(.footnote)
        } footer: {
            Text("The selected theme will affect many components other than listed above throughout the app.")
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: PREVIEWS
struct RoundedRectangularButtonSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    RoundedRectangularButtonSection()
                        .preferredColorScheme(.dark)
                }
            }
            
            NavigationView {
                List {
                    RoundedRectangularButtonSection()
                }
            }
        }
        .listStyle(.grouped)
        .environmentObject(ColorTheme())
    }
}
