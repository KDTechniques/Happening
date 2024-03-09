//
//  ThemeColorPickerView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-18.
//

import SwiftUI

struct AppearanceView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    // MARK: BODY
    var body: some View {
        List {
            ThemeColorPickerSection()
            
            NavigationBarWithButtonSection()
            
            SearchBarWithButtonsSection()
            
            MessageBarSection()
            
            TextButtonSection()
            
            RoundedRectangularButtonSection()
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Appearance")
    }
}

// MARK: PREVIEWS
struct ThemeColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            NavigationView {
                AppearanceView().preferredColorScheme(.dark)
            }
            NavigationView {
                AppearanceView()
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(ThemeColorPickerViewModel())
        .environmentObject(ProfileBasicInfoViewModel())
    }
}
