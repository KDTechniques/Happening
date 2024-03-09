//
//  ReserevedHappeningModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-02.
//

import Foundation

struct ReserevedHappeningModel: Identifiable {
    
    init(data:[String:Any]) {
        
        id = UUID().uuidString
        
        happeningDocID = data["HappeningID"] as? String ?? ""
        creatorUID = data["CreatorID"] as? String ?? ""
    }
    
    let id: String
    let happeningDocID: String
    let creatorUID: String
}
