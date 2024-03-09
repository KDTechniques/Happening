//
//  ParticipatorMessageItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-06.
//

import SwiftUI
import SDWebImageSwiftUI

struct ParticipatorMessageItemView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var currentUser: CurrentUser
    
    let item: MessageAsAParticipatorModel
    
    @State private var UnreadMsgCount: Int = 0
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                WebImage(url: URL(string: item.happeningDataWithProfileData.profilePhotoThumbnailURL))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Image(systemName: "person.crop.circle.fill")
                                    .foregroundColor(.gray)
                                    .background(.white)
                            )
                    }
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                    .clipShape(Circle())
                    .frame(width: 50, alignment: .trailing)
                
                Text(item.happeningDataWithProfileData.userName)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Spacer()
            }
            .frame(height: 15)
            .padding(.horizontal)
            
            HStack {
                WebImage(url: URL(string: item.happeningDataWithProfileData.thumbnailPhotoURL))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                    }
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: 50, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 2)  {
                    HStack {
                        Text(item.happeningDataWithProfileData.title)
                            .font(.footnote.weight(.medium))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .frame(maxWidth: 230, alignment: .leading)
                        
                        Spacer()
                        
                        Text(item.chatDataArray[item.chatDataArray.count-1].sentTime)
                            .font(.footnote)
                            .foregroundColor(UnreadMsgCount == 0 ? .secondary : color.accentColor)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.happeningDataWithProfileData.followingStatus
                                 ? item.happeningDataWithProfileData.address : item.happeningDataWithProfileData.secureAddress
                            )
                            
                            Text("\(item.happeningDataWithProfileData.startingDateTime) - \(item.happeningDataWithProfileData.endingDateTime)")
                            
                            Text(item.happeningDataWithProfileData.spaceFee)
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: 230, alignment: .leading)
                        
                        Spacer()
                        
                        Text("\(UnreadMsgCount)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .onAppear {
                                UnreadMsgCount = 0
                                for item in item.chatDataArray {
                                    if let myUserUID = currentUser.currentUserUID {
                                        if item.receiverUID == myUserUID && !item.isUpdated {
                                            UnreadMsgCount += 1
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, UnreadMsgCount > 9 ? 8 : 0)
                            .frame(width: UnreadMsgCount < 10 ? 18 : nil, height: 18)
                            .background(color.accentColor)
                            .opacity(UnreadMsgCount == 0 ? 0 : 1)
                            .cornerRadius(.infinity)
                    }
                    
                    HStack(alignment: .bottom) {
                        Text(item.chatDataArray[item.chatDataArray.count-1].msgText)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .frame(maxWidth: 230, alignment: .leading)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        if let myuserUID = currentUser.currentUserUID {
                            Text(item.happeningDataWithProfileData.participators.contains(myuserUID) ? "Reserved" : "Not Reserved")
                                .font(.footnote)
                                .foregroundColor(item.happeningDataWithProfileData.participators.contains(myuserUID) ? .green : .secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 15)
            .padding(.horizontal)
            .overlay(alignment: .bottom) {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Divider()
                            .frame(maxWidth: UIScreen.main.bounds.size.width - 75)
                    }
                }
            }
        }
        .padding(.top, 15)
    }
}
