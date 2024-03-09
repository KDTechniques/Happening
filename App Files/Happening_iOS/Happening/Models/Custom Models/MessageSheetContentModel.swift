//
//  MessageSheetContentModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-04.
//

import Foundation
import Firebase

struct MessageSheetContentModel: Identifiable, Codable, Equatable {
    
    init(data: [String: Any]) {
        
        id = UUID().uuidString
        
        happeningDocID = data["HappeningDocID"] as? String ?? ""
        happeningTitle = data["HappeningTitle"] as? String ?? ""
        senderUID = data["SenderUID"] as? String ?? ""
        receiverUID = data["ReceiverUID"] as? String ?? ""
        msgText = data["MsgText"] as? String ?? ""
        chatDocID = data["ChatDocID"] as? String ?? ""
        isSent = data["isSent"] as? Bool ?? false
        isDelivered = data["isDelivered"] as? Bool ?? false
        isRead = data["isRead"] as? Bool ?? false
        sentTime = data["SentTime"] as? String ?? "..."
        sentTimeFull = data["SentTimeFull"] as? String ?? "..."
        isUpdated = data["isUpdated"] as? Bool ?? false
        reactionString = data["Reaction"] as? String ?? ""
    }
    
    let id: String
    
    let happeningDocID: String
    let happeningTitle: String
    let senderUID: String
    let receiverUID: String
    let msgText: String
    let chatDocID: String
    var isSent: Bool
    var isDelivered: Bool
    let isRead: Bool
    let sentTime: String
    let sentTimeFull: String
    let isUpdated: Bool
    
    var reactionString: String
    var reaction: ReactorEmojiTypes {
        switch reactionString {
        case "👍":
            return .okay
            
        case "❤️":
            return .heart
            
        case "😂":
            return .haha
            
        case "😮":
            return .wow
            
        case "😢":
            return .sad
            
        case "🙏":
            return .please
            
        default:
            return .none
        }
    }
}
