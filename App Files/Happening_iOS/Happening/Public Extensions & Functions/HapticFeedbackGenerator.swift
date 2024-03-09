//
//  HapticFeedbackGenerator.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-10.
//

import Foundation
import SwiftUI

let generator = UINotificationFeedbackGenerator()
let popup = UIImpactFeedbackGenerator(style: .medium)

public func vibrate(type: VibrationType) {
    switch type {
    case .success:
        generator.notificationOccurred(.success)
        
    case .error:
        generator.notificationOccurred(.error)
        
    case .warning:
        generator.notificationOccurred(.warning)
        
    case .popup:
        popup.impactOccurred()
    }
}
