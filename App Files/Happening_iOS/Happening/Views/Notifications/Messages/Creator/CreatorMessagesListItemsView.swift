//
//  CreatorMessagesListItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-18.
//

import SwiftUI

struct CreatorMessagesListItemsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var creatorMessagesVM: CreatorMessagesViewModel
    @EnvironmentObject var currentUser: CurrentUser
    @EnvironmentObject var networkManger: NetworkManger
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(searchText: $creatorMessagesVM.searchTextCreatorMessages, isSearching: $creatorMessagesVM.isSearchingCreatorMessages)
            
            List(creatorMessagesVM.sortedMessagesAsACreatorChatDataArray) { item in
                
                if networkManger.connectionStatus == .connected {
                    CreatorMessageListItemView(item: item)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            creatorMessagesVM.sheetItemForCreatorMessagesListItemsView = item
                        }
                } else {
                    Text("Please check your phone's connection and try again.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .overlay(
                VStack {
                    ZStack {
                        ProgressView()
                            .tint(.secondary)
                            .opacity(creatorMessagesVM.showProgressViewForCreatorMessages ? 1 : 0)
                        
                        Text("No current messages available at the moment.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .opacity(creatorMessagesVM.showNoMessagesForCreatorMessages ? 1 : 0)
                        
                        Text("No results found.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .opacity(creatorMessagesVM.showNoResultsFoundForCreatorMessages ? 1 : 0)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            )
            .onChange(of: creatorMessagesVM.sortedMessagesAsACreatorChatDataArray) { newValue in /// newValue[0].chatData - means the top latest chat data set
                if let _ = creatorMessagesVM.sheetItemForCreatorMessagesListItemsView {
                    if creatorMessagesVM.sheetItemForCreatorMessagesListItemsView?.happeningDocID == newValue[0].happeningDocID && creatorMessagesVM.sheetItemForCreatorMessagesListItemsView?.chatData[0].senderUID == newValue[0].chatData[0].senderUID {
                        creatorMessagesVM.sheetItemForCreatorMessagesListItemsView?.chatData = newValue[0].chatData
                    }
                }
            }
            .sheet(item: $creatorMessagesVM.sheetItemForCreatorMessagesListItemsView) { item in
                MessageSheetContentView(
                    chatDataArrayItem: .constant(item.chatData),
                    profilePhotoThumURL: item.profilePhotoThumbnailURL,
                    happeningDocID: item.happeningDocID,
                    happeningTitle: item.happeningTitle,
                    receiverUID: item.chatData[0].senderUID != currentUser.currentUserUID
                    ? item.chatData[0].senderUID
                    : item.chatData[0].receiverUID,
                    receiverName: item.userName
                )
            }
        }
    }
}

// MARK: PREVIEWS
struct CreatorMessagesListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorMessagesListItemsView()
            .environmentObject(CreatorMessagesViewModel())
            .environmentObject(ColorTheme())
            .environmentObject(CurrentUser())
    }
}
