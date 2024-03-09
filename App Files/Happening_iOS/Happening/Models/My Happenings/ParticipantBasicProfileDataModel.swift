//
//  ParticipantBasicProfileDataModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import Foundation

struct ParticipantBasicProfileDataModel: Identifiable, Codable {
    
    init(data: [String: Any], documentID: String) {
        
        id = UUID().uuidString
        
        userUID = documentID
        profilePhotoThumnailURL = data["ProfilePhotoThumbnail"] as? String ?? ""
        userName = data["UserName"] as? String ?? ""
        profession = data["Profession"] as? String ?? ""
        ratings = data["Ratings"] as? Double ?? 0
    }
    
    let id: String // UUID().uuidString
    
    let userUID: String
    let profilePhotoThumnailURL: String
    let userName: String
    let profession: String
    let ratings: Double
}
