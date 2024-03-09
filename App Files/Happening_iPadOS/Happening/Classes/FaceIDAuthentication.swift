//
//  FaceIDAuthentication.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-16.
//

import Foundation
import LocalAuthentication

final class FaceIDAuthentication: ObservableObject {
    
    static let shared = FaceIDAuthentication()
    
    let isFaceIDAuthenticationEnabled: Bool = true
    @Published var isUnlocked = false
    @Published var isNoBiometricAlertPresented: Bool = false
    @Published var isReauthenticationEnabled: Bool = false
    
    let userDefaultsKeyName: String = "BioMetricsStatus"
    let context = LAContext()
    var error: NSError?
    
    func authenticate() {
        // check whether Face ID authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // if Face ID fails, go with Passcode athentication
            let reason = "Passcode is required to use Happening."
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.isReauthenticationEnabled = false
                        self.isUnlocked = true
                    } else {
                        // athentication unsuccessful
                        // reathentiactation with permission
                        self.isReauthenticationEnabled = true
                    }
                }
            }
        }
        else {
            // no biometrics
            self.isNoBiometricAlertPresented = true
        }
    }
    
    func passCodeAuthentication() {
        let reason = "Passcode is required to use Happening."
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    // authenticated successfully
                    self.isReauthenticationEnabled = false
                    self.isUnlocked = true
                } else {
                    // athentication unsuccessful
                    // reathentiactation with permission
                    self.isReauthenticationEnabled = true
                }
            }
        }
    }
}

