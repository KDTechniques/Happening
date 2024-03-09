//
//  FollowingsMemoriesModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-08.
//

import Foundation
import SwiftUI

struct FollowingsMemoriesModel: Identifiable, Codable, Equatable, Hashable {
    
    init(memoryDocID: String, memoriesDocData: [String:Any], compressedThumbnailImageData: Data?, compressedImageData: Data?, followingUserBasicProfileData: BasicFollowingUserProfileDataModel, isSeen: Bool) {
        
        id = memoryDocID
        memoryType = (memoriesDocData["MemoryType"] as? String ?? "" == "imageBased") ? .imageBased : .textBased
        colorName = memoriesDocData["ColorName"] as? String ?? "SBColor\(Int.random(in: 1..<22))"
        fontName = memoriesDocData["FontName"] as? String ?? "SFUIDisplay-Medium"
        text = memoriesDocData["Text"] as? String ?? "..."
        imageThumbnailURL = memoriesDocData["ImageThumbnailURL"] as? String ?? ""
        imageURL = memoriesDocData["ImageURL"] as? String ?? ""
        uploadedDate = memoriesDocData["UploadedDate"] as? String ?? ""
        uploadedTime = memoriesDocData["UploadedTime"] as? String ?? ""
        fullUploadedDT = memoriesDocData["FullUploadedDT"] as? String ?? ""
        caption = memoriesDocData["Caption"] as? String ?? ""
        userUID = followingUserBasicProfileData.userUID
        userName = followingUserBasicProfileData.userName
        profilePhotoThumbnailURL = followingUserBasicProfileData.profilePhotoThumbnailURL
        profession = followingUserBasicProfileData.profession
        self.isSeen = isSeen
        self.compressedThumbnailImageData = compressedThumbnailImageData
        self.compressedImageData = compressedImageData
    }
    
    let id: String // DocID
    
    let memoryType: MemoryTypes
    
    // text-based
    let colorName: String
    let fontName: String
    let text: String
    
    // image-based
    let imageThumbnailURL: String
    let imageURL: String
    let caption: String
    var compressedThumbnailImageData: Data?
    var compressedImageData: Data?
    
    let uploadedDate: String // ex: May 22, 2022
    let uploadedTime: String // ex: 4:46 PM
    let fullUploadedDT: String // ex: 22-05-2022 21:10:16
    
    // profile data
    let userUID: String
    let userName: String
    let profilePhotoThumbnailURL: String
    let profession: String
    
    var isSeen: Bool
}
