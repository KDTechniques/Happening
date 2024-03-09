//
//  TextBasedMyMemoryImageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-01.
//

import SwiftUI

struct TextBasedMyMemoryImageView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    let memoriesData: [MyMemoriesModel]
    
    @State private var image: UIImage?
    
    // MARK: BODY
    var body: some View {
        if let data = memoriesData[memoriesVM.selectedMyMemoryIndex].compressedImageData {
            Image(uiImage: UIImage(data: data)!)
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight)
        }
    }
}
