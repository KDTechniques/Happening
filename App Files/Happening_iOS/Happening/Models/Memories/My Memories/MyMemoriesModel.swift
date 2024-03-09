//
//  ImageStatusViewReadModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-08.
//

import Foundation
import SwiftUI

struct MyMemoriesModel: Identifiable, Codable, Equatable {
    
    init(uuid: String, data: [String:Any], compressedThumbnailImageData: Data?, compressedImageData: Data?, seenersData: [SeenersDataModel], uploadStatus: UploadStatusTypes) {
        
        id = uuid // DocID
        memoryType = (data["MemoryType"] as? String ?? "" == "imageBased") ? .imageBased : .textBased
        colorName = data["ColorName"] as? String ?? "SBColor\(Int.random(in: 1..<22))"
        fontName = data["FontName"] as? String ?? "SFUIDisplay-Medium"
        text = data["Text"] as? String ?? "..."
        imageThumbnailURL = data["ImageThumbnailURL"] as? String ?? ""
        imageURL = data["ImageURL"] as? String ?? ""
        uploadedDate = data["UploadedDate"] as? String ?? ""
        uploadedTime = data["UploadedTime"] as? String ?? ""
        fullUploadedDT = data["FullUploadedDT"] as? String ?? ""
        caption = data["Caption"] as? String ?? ""
        self.seenersData = seenersData
        self.uploadStatus = uploadStatus
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
    
    let seenersData: [SeenersDataModel]
    
    var uploadStatus: UploadStatusTypes
}
