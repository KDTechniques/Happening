//
//  UnreadStatusModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-09.
//

import Foundation

struct UnreadStatusModel: Identifiable, Equatable {
    
    let id: String = UUID().uuidString
    
    let happeningDocID: String
    var showUnreadCircle: Bool
}
