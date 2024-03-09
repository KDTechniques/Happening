//
//  ThemeColorPickerSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-05.
//

import SwiftUI

struct ThemeColorPickerSection: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeColorPickerViewModel: ThemeColorPickerViewModel
    
    // MARK: BODY
    var body: some View {
        Section {
            Picker("", selection: $themeColorPickerViewModel.themeColorSelection) {
                ForEach(ThemeColorOptions.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: themeColorPickerViewModel.themeColorSelection, perform: { value in
                themeColorPickerViewModel.setThemeColor(option: themeColorPickerViewModel.themeColorSelection)
            })
        } header: {
            Text("Select a Theme")
                .font(.footnote)
        } footer: {
            Text("By selecting a theme will affect the accent color of many components throughout the app.")
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: PREVIEWS
struct ThemeColorPickerSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    ThemeColorPickerSection()
                        .preferredColorScheme(.dark)
                }
            }
            
            NavigationView {
                List {
                    ThemeColorPickerSection()
                }
            }
        }
        .listStyle(.grouped)
        .environmentObject(ColorTheme())
        .environmentObject(SettingsViewModel())
        .environmentObject(ThemeColorPickerViewModel())
    }
}
