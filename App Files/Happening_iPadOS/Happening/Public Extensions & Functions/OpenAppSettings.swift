//
//  OpenAppSettings.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-16.
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
