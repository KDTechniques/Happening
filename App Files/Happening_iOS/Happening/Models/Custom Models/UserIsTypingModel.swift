//
//  UserIsTypingModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-31.
//

import Foundation

struct UserIsTypingModel: Identifiable, Equatable {
    
    init(data: [String: Any]) {
        
        id = UUID().uuidString
        
        happeningDocID = data["HappeningDocID"] as? String ?? ""
        isTyping = data["isTyping"] as? Bool ?? false
        typingUserUID = data["TypingUserUID"] as? String ?? ""
    }
    
    let id: String // UUID().uuidString
    
    let happeningDocID: String
    var isTyping: Bool
    let typingUserUID: String
}
