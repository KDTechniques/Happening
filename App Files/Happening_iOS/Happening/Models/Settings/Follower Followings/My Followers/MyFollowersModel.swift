//
//  MyFollowersModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import Foundation

struct MyFollowersModel: Identifiable, Equatable {
    
    init(dataSet: [String:Any], docID: String, amIFollowingUser: Bool) {
        
        id = docID
        self.amIFollowingUser = amIFollowingUser
        
        followedDT = dataSet["FollowedDT"] as? Date ??  Date()
        isBlocked = dataSet["isBlocked"] as? Bool ?? true
        profilepictureThumbnailURL = dataSet["ProfilePhotoThumbnail"] as? String ?? ""
        userName = dataSet["UserName"] as? String ?? "..."
        profession = dataSet["Profession"] as? String ?? "..."
    }
    
    let id: String
    
    let followedDT: Date
    let isBlocked: Bool
    var amIFollowingUser: Bool
    
    let profilepictureThumbnailURL: String
    let userName: String
    let profession: String
}
