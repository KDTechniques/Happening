//
//  HappeningDocIDNCreatorUIDModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-07.
//

import Foundation

struct HappeningDocIDNCreatorUIDModel {
    
    init(happeningDocID: String, creatorUID: String) {
        self.happeningDocID = happeningDocID
        self.creatorUID =  creatorUID
    }
    
    let happeningDocID: String
    let creatorUID: String
}
