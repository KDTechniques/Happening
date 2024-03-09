//
//  UserProfileInfoViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-18.
//

import Foundation

class UserProfileInfoViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = UserProfileInfoViewModel()
    
    // a data object that conforms to PublicProfileInfoModel
    @Published var data: PublicProfileInfoModel?
    
    // present an alert item for UserProfileInfoView
    @Published var alertItemForUserProfileInfoView: AlertItemModel?
    
    // present an action sheet item for UserProfileInfoView
    @Published var actionSheetItemForUserProfileInfoView: RemoveBlockUnblockFollowerActionSheetModel?
}
