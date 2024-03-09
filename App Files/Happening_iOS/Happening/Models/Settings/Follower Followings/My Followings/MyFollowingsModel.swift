//
//  MyFollowingsModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import Foundation

struct MyFollowingsModel: Identifiable, Equatable {
    
    init(dataSet: [String:Any], docID: String) {
        
        id = docID
        
        followedDT = dataSet["FollowedDT"] as? Date ??  Date()
        isBlocked = dataSet["isBlocked"] as? Bool ?? true
        profilepictureThumbnailURL = dataSet["ProfilePhotoThumbnail"] as? String ?? ""
        userName = dataSet["UserName"] as? String ?? "..."
        profession = dataSet["Profession"] as? String ?? "..."
    }
    
    let id: String
    
    let followedDT: Date
    let isBlocked: Bool
    
    let profilepictureThumbnailURL: String
    let userName: String
    let profession: String
}
