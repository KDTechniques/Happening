//
//  ViewersSheetContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct ViewersSheetContentView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    let item: [SeenersDataModel]
    
    @Binding var showSheet: Bool
    
    let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    // MARK: BODY
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("\(item.count) view\((item.count == 1) ? "" : "s")")
                        .font(.subheadline.weight(.semibold))
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring()) {
                            showSheet = false
                            memoriesVM.resumeMemoryProgressBar()
                            memoriesVM.pauseMemoryUploadDTCalculatorTimer()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .tint(.secondary)
                            .frame(width: 23)
                    }
                    
                }
                .padding(.vertical, 12)
                
                Divider()
                
                if item.count != 0 {
                    List(item) { seenerDataItem in
                        VStack(spacing: 0) {
                            HStack {
                                // profile photo thumbnail
                                WebImage(url: URL(string: seenerDataItem.profilePhotoThumbnailURL))
                                    .resizable()
                                    .placeholder {
                                        Rectangle()
                                            .fill(.ultraThinMaterial)
                                    }
                                    .indicator(.activity)
                                    .scaledToFill()
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                
                                // user name
                                Text(seenerDataItem.userName)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                HStack(spacing: 0) {
                                    // seen date
                                    Text(memoriesVM.memoriesUploadedDateOrTimeCalculator(
                                        fullUploadedDT: seenerDataItem.fullSeenDT,
                                        date: seenerDataItem.seenDate,
                                        time: seenerDataItem.seenTime).contains("ago") ? "today"
                                         : memoriesVM.memoriesUploadedDateOrTimeCalculator(
                                            fullUploadedDT: seenerDataItem.fullSeenDT,
                                            date: seenerDataItem.seenDate,
                                            time: seenerDataItem.seenTime)
                                    )
                                        .foregroundColor(.secondary)
                                        .font(.caption2)
                                        .frame(width: 135)
                                    
                                    // seen time
                                    Text(seenerDataItem.seenTime)
                                        .font(.caption)
                                        .frame(width: 55, alignment: .trailing)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .lineLimit(1)
                            
                            Divider()
                                .padding(.leading, 35+8)
                                .opacity((item.firstIndex(of: seenerDataItem) == item.count-1) ? 0 : 1)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(.plain)
                } else {
                    VStack {
                        Text("No views yet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top)
                        
                        Spacer()
                    }
                }
            }
            .padding(.bottom, 25)
            .frame(height: screenHeight/2)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(Color(UIColor.secondarySystemBackground).opacity(0.95))
            .cornerRadius(10)
            .offset(y: showSheet
                    ? (item.count > 0) ? 0 : screenHeight/3.1
                    : screenHeight/2
            )
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom)
        .gesture(DragGesture())
    }
}
