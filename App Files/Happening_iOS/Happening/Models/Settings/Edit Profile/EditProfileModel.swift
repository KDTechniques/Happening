//
//  ProfileBasicInfoModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-28.
//

import Foundation
import SwiftUI

struct EditProfileModel {
    
    init(data: [String:Any]) {
        userName = data["UserName"] as? String ?? "..."
        about = data["About"] as? String ?? "..."
        profession = data["Profession"] as? String ?? "..."
        
        let fn = data["FullName"] as? [String:String]
        firstName = fn?["FirstName"] ?? ""
        middleName = fn?["MiddleName"] ?? ""
        lastName = fn?["LastName"] ?? ""
        surName = fn?["SurName"] ?? ""
        fullName = "\(firstName) \(middleName) \(lastName) \(surName)".replacingOccurrences(of: "  ", with: " ")
        
        let fa = data["Address"] as? [String:String]
        street1 = fa?["Street1"] ?? ""
        street2 = fa?["Street2"] ?? ""
        city = fa?["City"] ?? ""
        postcode = fa?["Postcode"] ?? ""
        address = "\(street1), \(street2), \(city) \(postcode)".replacingOccurrences(of: ", ,", with: ",")
        
        phoneNo = data["PhoneNo"] as? String ?? "..."
        email = data["EmailAddress"] as? String ?? "..."
        nicNo = data["NICNo"] as? String ?? "..."
        dateOfBirth = data["BirthDate"] as? String ?? "..."
        gender = data["Gender"] as? String ?? "..."
    }
    
    var userName: String
    var about: String
    var profession: String
    var fullName: String
    var firstName: String
    var middleName: String
    var lastName: String
    var surName: String
    var address: String
    var street1: String
    var street2: String
    var city: String
    var postcode: String
    var phoneNo: String
    var email: String
    var nicNo: String
    var dateOfBirth: String
    var gender: String
}
