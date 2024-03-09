//
//  TextButtonSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-05.
//

import SwiftUI

struct TextButtonSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    
    // MARK: BODY
    var body: some View {
        Section {
            HStack {
                Spacer()
                
                Text("Button")
                    .foregroundColor(color.accentColor)
                    .fontWeight(.semibold)
                
                Spacer()
            }
        } header: {
            Text("Sample Text Button")
                .font(.footnote)
        }
    }
}

// MARK: PREVIEWS
struct TextButtonSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    TextButtonSection()
                        .preferredColorScheme(.dark)
                }
            }
            
            NavigationView {
                List {
                    TextButtonSection()
                }
            }
        }
        .listStyle(.grouped)
        .environmentObject(ColorTheme())
    }
}
