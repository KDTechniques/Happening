//
//  FollowingsListItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import SwiftUI

struct FollowingsListItemsView: View {
    
    @EnvironmentObject var myfollowerFollowingsVM: MyFollowersFollowingsListViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    var body: some View {
        ScrollView {
            SearchBarView(searchText: $myfollowerFollowingsVM.followingsSearchText, isSearching: $myfollowerFollowingsVM.isSearchingFollowings)
                .padding(.top, 15)
                .padding(.bottom)
            
            HStack {
                HStack {
                    Text("Sort by\nfollowed")
                        .font(.caption2.weight(.medium))
                        .multilineTextAlignment(.leading)
                    
                    Picker("Sort by", selection: $myfollowerFollowingsVM.followingsSortingSelection) {
                        Text("Latest")
                            .tag(MyFollowersFollowingsListViewModel.followingsSortingTypes.followedLatest)
                        
                        Text("Earliest")
                            .tag(MyFollowersFollowingsListViewModel.followingsSortingTypes.followedEarliest)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                }
                
                Spacer()
                
            }
            .padding(.top)
            .padding(.horizontal)
            
            if(myfollowerFollowingsVM.myFollowingsDataArray.isEmpty) {
                Text(networkManager.connectionStatus == .connected ? "You are not following anyone at the moment." : "Please check your phone's connection and try again.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
                    .padding(.top, networkManager.connectionStatus == .connected ? 50 : 0)
            } else {
                if(myfollowerFollowingsVM.orderedMyFollowingItemsArray.isEmpty) {
                    Text(networkManager.connectionStatus == .connected ? "No results found." : "Please check your phone's connection and try again.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(myfollowerFollowingsVM.orderedMyFollowingItemsArray) { item in
                        FollowingsItemView(item: item)
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

struct FollowingsListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FollowingsListItemsView()
                .preferredColorScheme(.dark)
            
            FollowingsListItemsView()
        }
        .environmentObject(MyFollowersFollowingsListViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(NetworkManger())
    }
}
