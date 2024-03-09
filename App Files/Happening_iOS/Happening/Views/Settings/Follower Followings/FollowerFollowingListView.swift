//
//  FollowerFollowingListView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import SwiftUI

struct FollowerFollowingListView: View {
    
    // MARK: PROPERTIES
    
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var myfollowerFollowingsVM: MyFollowersFollowingsListViewModel
    
    let type: MyFollowersFollowingsListViewModel.followerFollowingSelectionTypes
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            Picker("Follower Following Selection", selection: $myfollowerFollowingsVM.followerFollowingSelection) {
                Text("\(myfollowerFollowingsVM.numberOfFollowers) Follower\(myfollowerFollowingsVM.numberOfFollowers > 1 ? "s" : "")")
                    .tag(MyFollowersFollowingsListViewModel.followerFollowingSelectionTypes.followers)
                
                Text("\(myfollowerFollowingsVM.numberOfFollowings) Following\(myfollowerFollowingsVM.numberOfFollowings > 1 ? "s" : "")")
                    .tag(MyFollowersFollowingsListViewModel.followerFollowingSelectionTypes.followings)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 10)
            
            Divider()
                .actionSheet(item: $myfollowerFollowingsVM.actionSheetItemForFollowerFollowingListView) { item in
                    ActionSheet(
                        title: Text(item.title),
                        message: Text(item.message),
                        buttons: [.destructive(Text(item.destructiveText.rawValue)){ item.removeBlockUnblockAction() }, .cancel()]
                    )
                }
            
            if(myfollowerFollowingsVM.followerFollowingSelection == .followers) {
                FollowersListItemsView()
            } else {
                FollowingsListItemsView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let value = myfollowerFollowingsVM.followerFollowingSelectionCoordinator {
                myfollowerFollowingsVM.followerFollowingSelection = value
            }  else {
                myfollowerFollowingsVM.followerFollowingSelection = type
            }
            
            myfollowerFollowingsVM.followerFollowingSelectionCoordinator = .none
        }
        .alert(item: $myfollowerFollowingsVM.alertItemForFollowerFollowingListView) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
        }
    }
}

// MARK: PREVIEWS
struct FollowerFollowingListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                FollowerFollowingListView(type: .followers)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack(spacing: 2) {
                                Image(systemName: "chevron.left")
                                    .font(.subheadline.weight(.semibold))
                                Text("Settings 🇺🇦")
                            }
                            .foregroundColor(ColorTheme.shared.accentColor)
                        }
                    }
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                FollowerFollowingListView(type: .followings)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack(spacing: 2) {
                                Image(systemName: "chevron.left")
                                    .font(.subheadline.weight(.semibold))
                                Text("Settings 🇺🇦")
                            }
                            .foregroundColor(ColorTheme.shared.accentColor)
                        }
                    }
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(MyFollowersFollowingsListViewModel())
        .environmentObject(NetworkManger())
    }
}
