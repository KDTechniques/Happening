//
//  MemorySeenerModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-18.
//

import Foundation

struct MemorySeenerModel: Identifiable, Codable {
    
    init(data: [String: Any]) {
        
        id = data["seenMemoryDocID"] as? String ?? ""
        fullSeenDT = data["fullSeenDT"] as? String ?? ""
        seenDate = data["seenDate"] as? String ?? ""
        seenTime = data["seenTime"] as? String ?? ""
        seenerUID = data["seenerUID"] as? String ?? ""
        followingUserUID = data["followingUserUID"] as? String ?? ""
    }
    
    init(id: String, fullSeenDT: String, seenDate: String, seenTime: String, seenerUID: String, followingUserUID: String) {
        self.id = id
        self.fullSeenDT = fullSeenDT
        self.seenDate = seenDate
        self.seenTime = seenTime
        self.seenerUID = seenerUID
        self.followingUserUID = followingUserUID
    }
    
    let id: String // memory doc id
    let fullSeenDT: String
    let seenDate: String
    let seenTime: String
    let seenerUID: String
    let followingUserUID: String
}
