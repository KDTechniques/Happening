//
//  Color.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-12.
//

import Foundation
import SwiftUI

final class ColorTheme: ObservableObject {
    
    // MARK: PROPERTIES
    
    // reference to ColorTheme class
    static let shared = ColorTheme()
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // control the Custom accentColors
    @Published var accentColor: Color = Color("AccentColorDefault")
    
    // user defauls key name to store theme color name
    let ThemeColorUserDefaultsKeyName: String = "ThemeColor"
    
    // MARK: INITIALIZERS
    init(){
        getAndSetThemeColor()
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getAndSetThemeColor
    func getAndSetThemeColor() {
        guard let userDefaultsValue = defaults.string(forKey: ThemeColorUserDefaultsKeyName) else { return }
        self.accentColor = Color(userDefaultsValue)
    }
    
    // MARK: resetThemeColor
    func resetThemeColor() {
        defaults.set("AccentColorDefault", forKey: ThemeColorUserDefaultsKeyName)
        getAndSetThemeColor()
    }
}
