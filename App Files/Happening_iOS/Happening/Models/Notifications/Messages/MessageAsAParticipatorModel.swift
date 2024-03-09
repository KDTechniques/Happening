//
//  MessageAsAParticipatorModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-07.
//

import Foundation

struct MessageAsAParticipatorModel: Identifiable, Equatable {
    
    init(happeningItemModelObject: HappeningItemModel, messageSheetContentModelObject: [MessageSheetContentModel]) {
        
        id = UUID().uuidString
        
        happeningDataWithProfileData = happeningItemModelObject
        chatDataArray = messageSheetContentModelObject
    }
    
    let id: String
    
    let happeningDataWithProfileData: HappeningItemModel
    let chatDataArray: [MessageSheetContentModel]
}
