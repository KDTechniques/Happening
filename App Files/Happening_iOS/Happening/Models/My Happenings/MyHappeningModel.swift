//
//  MyHappeningModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import Foundation

struct MyHappeningModel: Identifiable {
    
    init(data: [String:Any], documentID: String) {
        
        id = documentID
        
        thumbnailPhotoURL = data["ThumbnailPhoto"] as? String ?? ""
        title = data["Title"] as? String ?? "..."
        
        let location = data["Location"] as? [String:Any]
        address = location?["Address"] as? String ?? "..."
        latitude = location?["Latitude"] as? Double ?? 0
        longitude = location?["Longitude"] as? Double ?? 0
        
        let dateTime = data["DateAndTime"] as? [String:String]
        startingDateTime = dateTime?["Starting"] ?? "..."
        endingDateTime = dateTime?["Ending"] ?? "..."
        ssdt = dateTime?["SSDT"] ?? "..."
        sedt = dateTime?["SEDT"] ?? "..."
        
        spaceFee = data["SpaceFee"] as? String ?? "..."
        noOfSpaces = data["Spaces"] as? Int ?? 0
        
        photosURLArray = data["PhotosArray"] as? [String] ?? [""]
        description = data["Description"] as? String ?? "..."
        
        participatorsUIDArray = data["Participators"] as? [String] ?? []
    }
    
    let id: String
    
    // Brief Data
    let thumbnailPhotoURL: String
    let title: String
    let address: String
    let startingDateTime: String
    let endingDateTime: String
    let ssdt: String
    let sedt: String
    let spaceFee: String
    let noOfSpaces: Int
    
    // Full Data
    let photosURLArray:[String]
    let description: String
    let latitude: Double
    let longitude: Double
    
    let participatorsUIDArray: [String]
}
