//
//  FollowersListItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import SwiftUI

struct FollowersListItemsView: View {
    
    @EnvironmentObject var myfollowerFollowingsVM: MyFollowersFollowingsListViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    var body: some View {
        ScrollView {
            SearchBarView(searchText: $myfollowerFollowingsVM.followersSearchText, isSearching: $myfollowerFollowingsVM.isSearchingFollowers)
                .padding(.top, 15)
                .padding(.bottom)
            
            HStack {
                Text("All Followers")
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.top)
            .padding(.leading)
            
            if(myfollowerFollowingsVM.myFollowersDataArray.isEmpty) {
                Text(networkManager.connectionStatus == .connected ? "No one is following you at the moment." : "Please check your phone's connection and try again.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
                    .padding(.top, networkManager.connectionStatus == .connected ? 50 : 0)
            } else {
                if(myfollowerFollowingsVM.orderedMyFollowerItemsArray.isEmpty) {
                    Text(networkManager.connectionStatus == .connected ? "No results found." : "Please check your phone's connection and try again.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(myfollowerFollowingsVM.orderedMyFollowerItemsArray) { item in
                        FollowerItemView(item: item)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ProgressView()
                    .tint(.secondary)
                    .opacity(myfollowerFollowingsVM.isPresentedProgressView ? 1 : 0)
            }
        }
    }
}

struct FollowersListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FollowersListItemsView()
                .preferredColorScheme(.dark)
            
            FollowersListItemsView()
        }
        .environmentObject(MyFollowersFollowingsListViewModel())
        .environmentObject(NetworkManger())
    }
}
