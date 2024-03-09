//
//  ImageBasedMyFollowingsMemoryImageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageBasedMyFollowingsMemoryImageView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    @Binding var memoriesData: [FollowingsMemoriesModel]
    
    @State private var image: UIImage?
    
    // MARK: BODY
    var body: some View {
        ZStack {
            if let compressedImageBasedMemoryImageData = memoriesData[memoriesVM.selectedFollowingsMemoryIndex].compressedImageData {
                Image(uiImage: UIImage(data: compressedImageBasedMemoryImageData)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight)
            } else {
                WebImage(url: URL(string: memoriesData[memoriesVM.selectedFollowingsMemoryIndex].imageURL))
                    .onSuccess(perform: { _, data, _ in
                        if let compressedImageBasedMemoryImageData = data {
                            /// we don't neet to compress image data because it has bee compressed at the time of uploading it by the following user
                            /// so we already have the compressed data
                            /// once we got the compressed data, we need to save it in the item that is related to this purticular memory id in user defaults
                            var tempArray: [[FollowingsMemoriesModel]] = memoriesVM.getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: memoriesVM.myFollowingsMemoriesDataArrayUserDefaultsKeyName)
                            
                            if let index = tempArray.firstIndex(where: { $0 == memoriesData }) {
                                /// we don't need to handle the else statement when the index is not found
                                /// because when we don't find the index for some reason, we can still no need to handle the else because web async image framework will get the image url from firestore and display it.
                                
                                tempArray[index][memoriesVM.selectedFollowingsMemoryIndex].compressedImageData = compressedImageBasedMemoryImageData
                                
                                /// once the compressed image has been saved to array item of that index, we can save the array back to the user defaults
                                memoriesVM.saveCustomFollowingsMemoriesDataArrayToUserDefaults(
                                    array: tempArray,
                                    keyName: memoriesVM.myFollowingsMemoriesDataArrayUserDefaultsKeyName
                                )
                            }
                        }
                    })
                    .resizable()
                    .placeholder {
                        ZStack {
                            if let compressedImageBasedMemoryImageData = memoriesData[memoriesVM.selectedFollowingsMemoryIndex].compressedThumbnailImageData {
                                Image(uiImage: UIImage(data: compressedImageBasedMemoryImageData)!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth, height: screenHeight)
                                    .blur(radius: 10)
                            }
                            
                            MemoryLoadingProgressView()
                        }
                    }
                    .indicator { _, _ in
                        Circle()
                            .fill(.clear)
                            .frame(width: 5)
                            .onAppear {
                                print("Timer Paused 🐸🐸🐸")
                                memoriesVM.pauseMemoryProgressBar()
                            }
                            .onDisappear {
                                print("Timer Resumed 🦁🦁🦁")
                                memoriesVM.resumeMemoryProgressBar()
                            }
                    }
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight)
            }
        }
    }
}
