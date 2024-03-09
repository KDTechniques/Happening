//
//  CurrentHappeningChatDataModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-21.
//

import Foundation

struct MessageAsACreatorModel: Identifiable, Equatable {
    
    init(happeningDocID: String, chatData: [MessageSheetContentModel], userName: String, profilePhotoThumbnailURL: String) {
        id = UUID().uuidString
        
        self.happeningDocID = happeningDocID
        self.chatData = chatData
        
        if chatData.isEmpty {
            happeningTitle = "..."
        } else {
            happeningTitle = chatData[0].happeningTitle
        }
        
        self.userName = userName
        self.profilePhotoThumbnailURL = profilePhotoThumbnailURL
    }
    
    let id: String
    
    let happeningDocID: String
    let happeningTitle: String
    var chatData: [MessageSheetContentModel]
    let userName: String
    let profilePhotoThumbnailURL: String
}
