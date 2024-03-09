//
//  BlockedUserModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-18.
//

import Foundation
import Firebase

struct BlockedUserModel: Identifiable, Equatable {
    
    init(data: [String:Any], userUID: String) {
        
        id = userUID
        
        userName = data["UserName"] as? String ?? "..."
        profilePhotoThumbnailURL = data["ProfilePhotoThumbnail"] as? String ?? "..."
        about = data["About"] as? String ?? "..."
        profession = data["Profession"] as? String ?? "..."
     
        if let timestamp = data["BlockedDT"] as? Timestamp {
            
            let date1 = timestamp.dateValue()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            blockedDT = dateFormatter.string(from: date1)
            
            let date2 = timestamp.dateValue()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            blockedDTCustom = dateFormatter.string(from: date2)
            
        } else {
            blockedDT = ""
            blockedDTCustom = ""
        }
    }
    
    let id: String
    
    let userName: String
    let profilePhotoThumbnailURL: String
    let about: String
    let profession: String
    
    let blockedDT: String
    
    let blockedDTCustom: String
}
