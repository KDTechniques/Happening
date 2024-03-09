//
//  TourchOperator.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-19.
//

import Foundation
import SwiftUI
import AVFoundation

public func torchOperator(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    
    if device.hasTorch {
        do {
            try device.lockForConfiguration()
            
            if on == true {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    } else {
        print("Torch is not available")
    }
}
