//
//  CreatorMessageListItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-18.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreatorMessageListItemView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var currentUser: CurrentUser
    
    let item: MessageAsACreatorModel
    
    @State private var UnreadMsgCount: Int = 0
    
    // MARK: BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                WebImage(url: URL(string: item.profilePhotoThumbnailURL))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                    }
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.happeningTitle)
                            .font(.subheadline.weight(.medium))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(item.chatData[item.chatData.count-1].sentTime)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                    }
                    
                    Text(item.userName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(item.chatData[item.chatData.count-1].msgText)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .frame(height: 50)
                .overlay(alignment: .bottomTrailing) {
                    Text("\(UnreadMsgCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .onAppear {
                            UnreadMsgCount = 0
                            for item in item.chatData {
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
                        .padding(.trailing)
                }
            }
            
            Divider()
                .padding(.leading, 58)
                .padding(.top, 14)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 14)
        .padding(.leading)
    }
}

// MARK: PREVIEWS
struct CreatorMessageListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorMessageListItemView(
            item: MessageAsACreatorModel(
                happeningDocID: "",
                chatData: [MessageSheetContentModel(
                    data: [
                        "MsgText":"This is a sample message",
                        "HappeningTitle":"Assembling a Gaming PC 👨🏻‍💻",
                        "SentTime": "12:38 PM"
                    ])],
                userName: "Kavinda Dilshan",
                profilePhotoThumbnailURL: "https://firebasestorage.googleapis.com/v0/b/happening-8133c.appspot.com/o/Profile%20Data%2FProfile%20Pictures%2FUiL9A2ZqzeSsa79g86KPeKseUNA2%2FEC9FD5C1-3E0C-4F49-8C93-EB4CB7ED2DF8?alt=media&token=47f7c920-70b0-487c-af35-db9856192cff")
        )
            .preferredColorScheme(.dark)
            .environmentObject(ColorTheme())
            .environmentObject(CurrentUser())
    }
}
