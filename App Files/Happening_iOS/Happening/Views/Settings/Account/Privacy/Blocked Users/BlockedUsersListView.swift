//
//  BlockedUsersView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-18.
//

import SwiftUI

struct BlockedUsersListView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var blockedUsersVM: BlockedUsersViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // MARK: BODY
    var body: some View {
        ScrollView {
            VStack {
                SearchBarView(searchText: $blockedUsersVM.blockedUsersSearchingText, isSearching: $blockedUsersVM.isSearchingBlockedUser)
                    .padding(.top, 15)
                    .padding(.bottom)
                
                HStack {
                    HStack {
                        Text("Sort by\nblocked")
                            .font(.caption2.weight(.medium))
                            .multilineTextAlignment(.leading)
                        
                        Picker("Sort by", selection: $blockedUsersVM.blockUsersSortingSelection) {
                            Text("Latest")
                                .tag(BlockedUsersViewModel.blockUsersSortingTypes.blockedLatest)
                            
                            Text("Earliest")
                                .tag(BlockedUsersViewModel.blockUsersSortingTypes.blockEarliest)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 150)
                    }
                    
                    Spacer()
                }
                .padding()
                
                if(blockedUsersVM.blockedUsersDataArray.isEmpty) {
                    Text(networkManager.connectionStatus == .connected ? "You have not blocked anyone at the moment." : "Please check your phone's connection and try again.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                        .padding(.top, networkManager.connectionStatus == .connected ? 50 : 0)
                } else {
                    if(blockedUsersVM.orderedBlockedItemsArray.isEmpty) {
                        Text(networkManager.connectionStatus == .connected ? "No results found." : "Please check your phone's connection and try again.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(blockedUsersVM.orderedBlockedItemsArray) { item in
                            BlockedUserItemView(item: item)
                            Divider()
                                .padding(.leading, 84)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Blocked")
                    .fontWeight(.semibold)
            }
        }
        .actionSheet(item: $blockedUsersVM.actionSheetItemForBlockedUsersListView) { item in
            ActionSheet(
                title: Text(item.title),
                message: Text(item.message),
                buttons: [.destructive(Text(item.destructiveText.rawValue)){ item.removeBlockUnblockAction() }, .cancel()]
            )
        }
    }
}

// MARK: PREVIEWS
struct BlockedUsersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BlockedUsersListView()
                .preferredColorScheme(.dark)
            
            BlockedUsersListView()
        }
        .environmentObject(BlockedUsersViewModel())
        .environmentObject(NetworkManger())
    }
}
