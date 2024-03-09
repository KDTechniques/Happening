//
//  SeenersDataModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-27.
//

import Foundation

struct SeenersDataModel: Identifiable, Equatable, Codable {
    
    init(docID: String, data: [String:Any]) {
        
        id = docID // UUID
        
        seenMemoryDocID = data["SeenMemoryDocID"] as? String ?? ""
        userUID = data["SeenerUID"] as? String ?? ""
        userName = data["UserName"] as? String ?? ""
        profilePhotoThumbnailURL = data["ProfilePhotoThumbnail"] as? String ?? ""
        seenTime = data["SeenTime"] as? String ?? ""
        seenDate = data["SeenDate"] as? String ?? ""
        fullSeenDT = data["FullSeenDT"] as? String ?? ""
    }
    
    let id: String // DocID
    
    let userUID: String
    let seenMemoryDocID: String
    let userName: String
    let profilePhotoThumbnailURL: String
    let seenTime: String // ex: 10:22 PM or 3:12 AM <-- to display
    let seenDate: String // ex: May 6, 2022 <-- to display
    let fullSeenDT: String // ex: 06-05-2022 23:45:34 <-- for sorting purposes
}
