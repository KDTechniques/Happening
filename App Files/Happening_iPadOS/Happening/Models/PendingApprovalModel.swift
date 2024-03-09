//
//  PendingApprovalModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-16.
//

import Foundation

struct PendingApprovalModel {
    
    init(data: [String:Any]) {
        id = data["DocumentID"] as? String ?? ""
        let fullName = data["FullName"] as? [String:String]
        firstName = fullName?["FirstName"] ?? ""
        middleName = fullName?["MiddleName"] ?? ""
        lastName = fullName?["LastName"] ?? ""
        surName = fullName?["SurName"] ?? ""
        nicNo = data["NICNo"] as? String ?? ""
        birthDate = data["BirthDate"] as? String ?? ""
        gender = data["Gender"] as? String ?? ""
        profession = data["Profession"] as? String ?? ""
        let address = data["Address"] as? [String:String]
        street1 = address?["Street1"] ?? ""
        street2 = address?["Street2"] ?? ""
        city = address?["City"] ?? ""
        postcode = address?["Postcode"] ?? ""
        emailAddress = data["EmailAddress"] as? String ?? ""
        phoneNo = data["PhoneNo"] as? String ?? ""
        let nicPhoto = data["NICPhoto"] as? [String:String]
        nicPhotoFrontSide = nicPhoto?["FrontSide"] ?? ""
        nicPhotoBackSide = nicPhoto?["BackSide"] ?? ""
        profilePhoto = data["ProfilePhoto"] as? String ?? ""
        deviceModel = data["DeviceModel"] as? String ?? ""
        about = data["About"] as? String ?? ""
    }
    
    var id: String
    var firstName: String
    var middleName: String
    var lastName: String
    var surName: String
    var nicNo: String
    var birthDate: String
    var gender: String
    var profession: String
    var street1: String
    var street2: String
    var city: String
    var postcode: String
    var emailAddress: String
    var phoneNo: String
    var nicPhotoFrontSide: String
    var nicPhotoBackSide: String
    var profilePhoto: String
    var deviceModel: String
    var about: String
}
