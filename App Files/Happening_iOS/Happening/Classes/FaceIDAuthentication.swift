//
//  FaceIDAuthentication.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-20.
//

import Foundation
import LocalAuthentication

final class FaceIDAuthentication: ObservableObject {
    
    static let shared = FaceIDAuthentication()
    
    @Published var isFaceIDAuthenticationEnabled: Bool = false
    @Published var isUnlocked = false
    @Published var isNoBiometricAlertPresented: Bool = false
    @Published var isReauthenticationEnabled: Bool = false
    
    let userDefaultsKeyName: String = "BioMetricsStatus"
    let context = LAContext()
    var error: NSError?
    
    init(){
        getAndSetFaceID()
    }
    
    func setFaceID() {
        
    }
    
    func getAndSetFaceID() {
        self.isFaceIDAuthenticationEnabled = UserDefaults.standard.bool(forKey: self.userDefaultsKeyName)
    }
    
    func resetFaceID() {
        UserDefaults.standard.set(false, forKey: userDefaultsKeyName)
        getAndSetFaceID()
    }
    
    func authenticate() {
        // check whether Face ID authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // if Face ID fails, go with Passcode athentication
            let reason = "Authentication is required to use Happening."
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
        let reason = "Authentication is required to use Happening."
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

