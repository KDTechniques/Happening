//
//  ApprovalFormModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-22.
//

import Foundation
import SwiftUI

struct ApprovalFormModel {
    // name model
    var firstName: String
    var middleName: String
    var lastName: String
    var surName: String
    var fullName: String
    
    // other model
    var profession: ProfessionType
    var nic: String
    var dateOfBirth: Date
    var gender: GenderType
    var age: String
    
    // address model
    var street1: String
    var street2: String
    var city: String
    var postCode: String
    var address: String
    
    // contactable model
    var email: String
    var spCode: String
    var phoneNo: String
    var fullPhoneNo: String
    
    // authenticity verification model
    var nicFrontImage: UIImage?
    var nicBackImage: UIImage?
    var profileImage: UIImage?
    
    // device model info
    var deviceModel: String = UIDevice.modelName
}
