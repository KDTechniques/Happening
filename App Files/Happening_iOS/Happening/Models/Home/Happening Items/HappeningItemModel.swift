//
//  HappeningItemModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-26.
//

import Foundation

struct HappeningItemModel: Identifiable, Equatable {
    
    init(data: [String:Any], happeningDocID: String, followingStatus: Bool) {
        
        id = happeningDocID
        
        thumbnailPhotoURL = data["ThumbnailPhoto"] as? String ?? ""
        title = data["Title"] as? String ?? "..."
        
        let location = data["Location"] as? [String:Any]
        address = location?["Address"] as? String ?? "..."
        secureAddress = location?["SecureAddress"] as? String ?? "..."
        latitude = location?["Latitude"] as? Double ?? 0
        longitude = location?["Longitude"] as? Double ?? 0
        
        let dateTime = data["DateAndTime"] as? [String:String]
        startingDateTime = dateTime?["Starting"] ?? "..."
        endingDateTime = dateTime?["Ending"] ?? "..."
        ssdt = dateTime?["SSDT"] ?? "..."
        sedt = dateTime?["SEDT"] ?? "..."
        
        spaceFee = data["SpaceFee"] as? String ?? "..."
        spaceFeeNo = data["SpaceFeeNo"] as? Int ?? 0
        photosURLArray = data["PhotosArray"] as? [String] ?? [""]
        description = data["Description"] as? String ?? "..."
        participators = data["Participators"] as? [String] ?? []
        dueFlag = data["DueFlag"] as? String ?? ""
        spaceFlag = data["SpaceFlag"] as?  String ?? ""
        
        // User Data
        userUID = data["UID"] as? String ?? "..."
        userName = data["UserName"] as? String ?? "..."
        profilePhotoThumbnailURL = data["ProfilePhotoThumbnail"] as? String ?? "..."
        profilePhotoURL = data["ProfilePhoto"] as? String ?? "..."
        phoneNo = data["PhoneNo"] as? String ?? "..."
        profession = data["Profession"] as? String ?? "..."
        ratings = data["Ratings"] as? Double ?? 0
        
        self.followingStatus = followingStatus
    }
    
    let id: String // happening document ID
    
    // Brief Data
    let thumbnailPhotoURL: String
    let title: String
    let address: String
    let secureAddress: String
    let startingDateTime: String
    let endingDateTime: String
    let ssdt: String
    let sedt: String
    let spaceFee: String
    let participators: [String]
    
    // Full Data
    let photosURLArray:[String]
    let description: String
    let latitude: Double
    let longitude: Double
    let spaceFeeNo: Int
    let dueFlag: String
    let spaceFlag: String
    
    // User Data
    let userUID: String
    let userName: String
    let profilePhotoURL: String
    let profilePhotoThumbnailURL: String
    let phoneNo: String
    let profession: String
    let ratings: Double
    
    let followingStatus: Bool
}
