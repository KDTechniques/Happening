//
//  PublicProfileInfoModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-15.
//

import Foundation
import SwiftUI

struct PublicProfileInfoModel: Identifiable {
    
    init(data: [String: Any], qrCodeUserUID: String, isQrCodeUserFollowingMe: Bool, amIFollowingQRCodeUser: Bool) {
        
        id = qrCodeUserUID
        
        profilePhotoThumbnailURL = data["ProfilePhoto"] as? String ?? ""
        userName = data["UserName"] as? String ?? "..."
        profession = data["Profession"] as? String ?? "..."
        about = data["About"] as? String ?? "..."
        ratings = data["Ratings"] as? CGFloat ?? 5
        let address = data["Address"] as? [String:String]
        city = address?["City"] ?? "..."
        let name = data["FullName"] as? [String:String]
        firstName = name?["FirstName"] ?? "..."
        middleName = name?["MiddleName"] ?? "..."
        lastName = name?["LastName"] ?? "..."
        surName = name?["SurName"] ?? "..."
        birthDate = data["BirthDate"] as? String ?? "..."
        gender = data["Gender"] as? String ?? "..."
        self.isQrCodeUserFollowingMe = isQrCodeUserFollowingMe
        self.amIFollowingQRCodeUser = amIFollowingQRCodeUser
        
        // get happening data later...
    }
    
    let id: String
    
    let profilePhotoThumbnailURL: String
    let userName: String
    let profession: String
    let about: String
    let ratings: CGFloat
    let city: String
    let firstName: String
    let middleName: String
    let lastName: String
    let surName: String
    let birthDate: String
    let gender: String
    
    let isQrCodeUserFollowingMe: Bool
    let amIFollowingQRCodeUser: Bool
    
    var fullName: String {
        let name = "\(firstName) \(middleName) \(lastName) \(surName)"
        return name.replacingOccurrences(of: "  ", with: " ")
    }
    
    var age: String {
        calculateAge(birthDate: birthDate)
    }
}
