//
//  BrightnessController.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-19.
//

import Foundation
import UIKit
import SwiftUI

class ViewController: UIViewController {
    @Published var previousBrightnessValue: CGFloat = 0.4
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.previousBrightnessValue = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0 // change this to 1.0 after done implementing the project.
    }
    
    @objc func toggle() {
        UIScreen.main.brightness = previousBrightnessValue
    }
}
