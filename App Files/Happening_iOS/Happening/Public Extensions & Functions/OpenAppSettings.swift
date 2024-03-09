//
//  OpenAppSettings.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-20.
//

import Foundation
import SwiftUI

public func goToAppSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
