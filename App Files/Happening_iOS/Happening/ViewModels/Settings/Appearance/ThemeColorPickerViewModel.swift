//
//  ThemeColorPickerViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI

class ThemeColorPickerViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = ThemeColorPickerViewModel()
    
    // reference to ColorTheme class
    let color = ColorTheme.shared
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // controls the theme color selection of the segment picker
    @Published var themeColorSelection: ThemeColorOptions = .realistic
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: setThemeColorSelection
    func setThemeColorSelection() {
        // Retrieve selection data of the segment picker from userdefaults when the SettingsView appears.
        guard let accentColor = defaults.string(forKey: color.ThemeColorUserDefaultsKeyName) else { return }
        color.accentColor = Color(accentColor)
        
        switch accentColor {
        case "AccentColorDefault":
            themeColorSelection = .realistic
            
        case "AccentColorModern":
            themeColorSelection = .modern
            
        case "AccentColorStylish":
            themeColorSelection = .stylish
            
        case "AccentColorContrast":
            themeColorSelection = .contrast
            
        default:
            themeColorSelection = .realistic
        }
    }
    
    // MARK: setThemeColor
    func setThemeColor(option: ThemeColorOptions){
        switch themeColorSelection {
        case .realistic:
            color.accentColor = Color("AccentColorDefault")
            
        case .modern:
            color.accentColor = Color("AccentColorModern")
            
        case .stylish:
            color.accentColor = Color("AccentColorStylish")
            
        case .contrast:
            color.accentColor = Color("AccentColorContrast")
        }
        
        defaults.set("AccentColor\(themeColorSelection.rawValue)", forKey: color.ThemeColorUserDefaultsKeyName)
    }
}
