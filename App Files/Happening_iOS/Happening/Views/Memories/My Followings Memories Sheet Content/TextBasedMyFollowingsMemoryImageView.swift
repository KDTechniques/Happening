//
//  TextBasedMyFollowingsMemoryImageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-09.
//

import SwiftUI

struct TextBasedMyFollowingsMemoryImageView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    @Binding var memoriesData: [FollowingsMemoriesModel]
    
    // MARK: BODY
    var body: some View {
        if let compressedTextBasedImageData = memoriesData[memoriesVM.selectedFollowingsMemoryIndex].compressedImageData {
            Image(uiImage: UIImage(data: compressedTextBasedImageData)!)
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight)
        }
    }
}
