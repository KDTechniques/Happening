//
//  BasicProfileDataModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-19.
//

import Foundation

struct BasicProfileInfoModel {
    
    init(data: [String:Any]) {
        profilePhotoURL = data["ProfilePhoto"] as? String ?? ""
        userName = data["UserName"] as? String ?? "..."
        about = data["About"] as? String ?? "..."
        profession = data["Profession"] as? String ?? "..."
    }
    
    var profilePhotoURL: String
    var userName: String
    var about: String
    var profession: String
}
