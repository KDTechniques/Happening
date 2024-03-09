//
//  VerificationStatus.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-23.
//

import Foundation

// represent the phone number or email authentication status
public enum VerificationStatus: String {
    case verify = "Verify" // that means still not verified
    case verified = "Verified"
}
