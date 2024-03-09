//
//  PhoneNoAuthManager.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-10.
//

import Foundation
import FirebaseAuth

class PhoneNoAuthManager: ObservableObject {
    
    // singleton
    static let shared = PhoneNoAuthManager()
    
    @Published var phoneNumber: String = ""
    private var verificationID: String = ""
    
    enum VerificationStatus {
        case error
        case success
    }
    
    func sendVerificationCode(completionHandler: @escaping (_ status: VerificationStatus, _ error: Error?) -> ()) {
        
        guard let countryPhoneCode = getCountryPhoneCode() else {return}
        
        let countryCodePhoneNumber = "+\(countryPhoneCode)\(phoneNumber.dropFirst())" // dropFirst() will remove the first '0' from the number
        
        PhoneAuthProvider.provider().verifyPhoneNumber(countryCodePhoneNumber, uiDelegate: nil) { [weak self] code, error in
            if let error = error {
                print("Error Sending Verification Code: \(error.localizedDescription)")
                completionHandler(.error, error)
                return
            } else {
                guard let code = code else { return }
                print("Verfication Code Sent Successfully 📩📩📩")
                self?.verificationID = code
                completionHandler(.success, nil)
            }
        }
    }
    
    func verifyCode(code: String, completionHandler: @escaping(_ status: VerificationStatus) -> ()) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print("Error Verifying The Entered Code: \(error.localizedDescription) 😕😕😕")
                completionHandler(.error)
                return
            } else {
                // Authentication Successful
                print("Phone Number Authentification Successful 📱📱📱")
                completionHandler(.success)
            }
        }
    }
}
