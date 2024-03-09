//
//  MyMemoriesMainListItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-27.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyMemoriesMainListItemView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var textBasedMyMemoriesVM: TextBasedMemoryViewModel
    @EnvironmentObject var imageBasedMemoriesVM: ImageBasedMemoryViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    let item: MyMemoriesModel
    
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
            if item.memoryType == .textBased {
                Image(uiImage: UIImage(data: item.compressedImageData!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .background(
                        MyMemoriesDottedCircle(count: memoriesVM.failedNSucceededMyMemoriesDataArray.count)
                    )
            } else { // image based memory
                if let compressedImageBasedMemoryImageData = item.compressedThumbnailImageData {
                    Image(uiImage: UIImage(data: compressedImageBasedMemoryImageData)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .background(
                            MyMemoriesDottedCircle(count: memoriesVM.failedNSucceededMyMemoriesDataArray.count)
                        )
                } else if let compressedImageBasedMemoryImageData = item.compressedImageData {
                    Image(uiImage: UIImage(data: compressedImageBasedMemoryImageData)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .background(
                            MyMemoriesDottedCircle(count: memoriesVM.failedNSucceededMyMemoriesDataArray.count)
                        )
                } else {
                    WebImage(url: URL(string: item.imageThumbnailURL))
                        .onSuccess(perform: { _, data, _ in
                            if let compressedImageBasedMemoryImageData = data {
                                /// we don't neet to compress image data because it has bee compressed at the time of uploading it
                                /// so we already have the compressed data
                                /// once we got the compressed data, we need to save it in the succeed my memories array in user defaults
                                var tempArray: [MyMemoriesModel] = memoriesVM.getExistingCustomMyMemoriesDataFromUserDefaults(keyName: memoriesVM.myMemoriesDataArrayUserDefaultsKeyName)
                                
                                /// we don't need to handle the else statement when the index is not found
                                /// because when we don't find the index for some reason, we can still no need to handle the else because web async image framework will get the image url from firestore and display it.
                                if let index = tempArray.firstIndex(where: { $0.id == item.id }) {
                                    tempArray[index].compressedThumbnailImageData = compressedImageBasedMemoryImageData
                                    
                                    /// once the compressed image has been saved to array item of that index, we can save the array back to the user defaults
                                    memoriesVM.saveCustomMemoriesDataArrayToUserDefaults(array: tempArray, keyName: memoriesVM.myMemoriesDataArrayUserDefaultsKeyName)
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
                            MyMemoriesDottedCircle(count: memoriesVM.failedNSucceededMyMemoriesDataArray.count)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("My Memories")
                    .fontWeight(.semibold)
                
                if memoriesVM.sendingCount > 0 {
                    HStack(spacing: 5) {
                        Image("msgPending")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                        
                        Text("Sending \(memoriesVM.sendingCount)")
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                } else {
                    switch item.uploadStatus {
                    case .uploaded:
                        if allowedTimeDifTextsArray.contains(
                            memoriesVM.memoriesUploadedDateOrTimeCalculator(
                                fullUploadedDT: item.fullUploadedDT,
                                date: item.uploadedDate,
                                time: item.uploadedTime)) {
                            
                            Text("\(memoriesVM.memoriesUploadedDateOrTimeCalculator(fullUploadedDT: item.fullUploadedDT, date: item.uploadedDate, time: item.uploadedTime)), \(item.uploadedTime)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            if ["AM", "PM"].contains(memoriesVM.memoriesUploadedDateOrTimeCalculator(
                                fullUploadedDT: item.fullUploadedDT,
                                date: item.uploadedDate,
                                time: item.uploadedTime)) {
                                Text(memoriesVM.memoriesUploadedDateOrTimeCalculator(
                                    fullUploadedDT: item.fullUploadedDT,
                                    date: item.uploadedDate,
                                    time: item.uploadedTime))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text(memoriesVM.memoriesUploadedDateOrTimeCalculator(fullUploadedDT: item.fullUploadedDT, date: item.uploadedDate, time: item.uploadedTime))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                    default:
                        HStack(spacing: 5) {
                            Image("msgPending")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12)
                            
                            Text("Sending")
                                .font(.subheadline)
                        }
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
        .onAppear {
            memoriesVM.sendingCount = 0
            for item in memoriesVM.failedNSucceededMyMemoriesDataArray {
                if item.uploadStatus == .pending || item.uploadStatus == .failed {
                    memoriesVM.sendingCount += 1
                }
            }
        }
    }
}
