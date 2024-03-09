//
//  FollowingsMemoriesListItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-08.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowingsMemoriesListItemView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var textBasedMyMemoriesVM: TextBasedMemoryViewModel
    @EnvironmentObject var imageBasedMemoriesVM: ImageBasedMemoryViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    let item: [FollowingsMemoriesModel]
    
    let allowedTimeDifTextsArray: [String] = [
        "yesterday",
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday"
    ]
    
    // MARK: BODY
    var body: some View {
        HStack(spacing: 14) {
            if item[item.count-1].memoryType == .textBased {
                Image(uiImage: UIImage(data: item[item.count-1].compressedImageData!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .background(
                        FollowingsMemoriesDottedCircle(
                            count: item.count,
                            isAllSeen: item.contains(where: { $0.isSeen == false }) ? false : true
                        )
                    )
            } else { // image based memory item
                if let compressedImageData = item[item.count-1].compressedThumbnailImageData {
                    Image(uiImage: UIImage(data: compressedImageData)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .background(
                            FollowingsMemoriesDottedCircle(
                                count: item.count,
                                isAllSeen: item.contains(where: { $0.isSeen == false }) ? false : true
                            )
                        )
                } else {
                    WebImage(url: URL(string: item[item.count-1].imageThumbnailURL))
                        .onSuccess(perform: { _, data, _ in
                            if let compressedImageBasedMemoryThumbnailImageData = data {
                                /// we don't neet to compress image data because it has bee compressed at the time of uploading it by the following user
                                /// so we already have the compressed data
                                /// once we got the compressed data, we need to save it in the item that is related to this purticular memory id in user defaults
                                var tempArray: [[FollowingsMemoriesModel]] = memoriesVM.getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: memoriesVM.myFollowingsMemoriesDataArrayUserDefaultsKeyName)
                                
                                if let index = tempArray.firstIndex(where: { $0 == item }) {
                                    /// we don't need to handle the else statement when the index is not found
                                    /// because when we don't find the index for some reason, we can still no need to handle the else because web async image framework will get the image url from firestore and display it.
                                    
                                    tempArray[index][item.count-1].compressedThumbnailImageData = compressedImageBasedMemoryThumbnailImageData
                                    
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
                            if networkManager.connectionStatus == .connected {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        ProgressView()
                                            .tint(.secondary)
                                    )
                                
                            } else {
                                Image(systemName: "photo.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                            }
                        }
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .background(
                            FollowingsMemoriesDottedCircle(
                                count: item.count,
                                isAllSeen: item.contains(where: { $0.isSeen == false }) ? false : true
                            )
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item[0].userName)
                    .fontWeight(.semibold)
                
                Text(item[0].profession)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                if allowedTimeDifTextsArray.contains(
                    memoriesVM.memoriesUploadedDateOrTimeCalculator(
                        fullUploadedDT: item[item.count-1].fullUploadedDT,
                        date: item[item.count-1].uploadedDate,
                        time: item[item.count-1].uploadedTime)) {
                    
                    Text("\(memoriesVM.memoriesUploadedDateOrTimeCalculator(fullUploadedDT: item[item.count-1].fullUploadedDT, date: item[item.count-1].uploadedDate, time: item[0].uploadedTime)), \(item[item.count-1].uploadedTime)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } else {
                    if ["AM", "PM"].contains(memoriesVM.memoriesUploadedDateOrTimeCalculator(
                        fullUploadedDT: item[item.count-1].fullUploadedDT,
                        date: item[item.count-1].uploadedDate,
                        time: item[item.count-1].uploadedTime)) {
                        Text(memoriesVM.memoriesUploadedDateOrTimeCalculator(
                            fullUploadedDT: item[item.count-1].fullUploadedDT,
                            date: item[item.count-1].uploadedDate,
                            time: item[item.count-1].uploadedTime))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } else {
                        Text(memoriesVM.memoriesUploadedDateOrTimeCalculator(fullUploadedDT: item[item.count-1].fullUploadedDT, date: item[item.count-1].uploadedDate, time: item[item.count-1].uploadedTime))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listRowBackground(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
        .listRowInsets(EdgeInsets())
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 75)
        .padding(.leading)
        .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
        .onTapGesture {
            memoriesVM.selectedFollowingUserMemoriesDataArrayItem = item
            memoriesVM.selectedFollowingsMemoryIndex = 0
            memoriesVM.isPresentedMyFollowingsMemoriesSheet = true
        }
    }
}
