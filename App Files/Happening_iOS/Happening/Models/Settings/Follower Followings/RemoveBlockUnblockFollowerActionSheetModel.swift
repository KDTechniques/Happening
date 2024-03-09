//
//  RemoveFollowerActionSheetModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-17.
//

import Foundation

struct RemoveBlockUnblockFollowerActionSheetModel: Identifiable {
    
    let id: String
    let removeBlockUnblockAction: () -> ()
    
    let title: String
    let message: String
    let destructiveText: UserDestructiveTypes
    
    enum UserDestructiveTypes: String {
        case remove = "Remove"
        case block = "Block"
        case unblock = "Unblock"
    }
}
