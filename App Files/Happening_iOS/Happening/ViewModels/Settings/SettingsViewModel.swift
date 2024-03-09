//
//  SettingsViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-27.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = SettingsViewModel()
    
    // icon width & height of main settings labels
    let iconWidthHeight: CGFloat = 28.0
    
    // present an action sheet when user tries to sign out
    @Published var isPresentedSignoutActionSheet: Bool = false
}
