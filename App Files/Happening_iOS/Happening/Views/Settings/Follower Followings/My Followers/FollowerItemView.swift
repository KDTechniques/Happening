//
//  FollowerItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowerItemView: View {
    
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var myFollowersFollowingsListVM: MyFollowersFollowingsListViewModel
    @EnvironmentObject var publicProfileInfoVM: PublicProfileInfoViewModel
    
    let item: MyFollowersModel
    
    @State var amIFollowingUser: Bool?
    
    var body: some View {
        HStack {
            NavigationLink {
                UserProfileInfoView(type: .followers, userUID: item.id)
            } label: {
                HStack {
                    WebImage(url: URL(string: item.profilepictureThumbnailURL))
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                        }
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(item.userName)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(.primary)
                            
                            Button {
                                myFollowersFollowingsListVM.isPresentedProgressView = true
                                myFollowersFollowingsListVM.FollowUnfollowDeterminer(userUID: item.id, amIFollowingQRCodeUser: item.amIFollowingUser) { status in
                                    if(status) {
                                        amIFollowingUser!.toggle()
                                    }
                                }
                            } label: {
                                if let amIFollowingUser = amIFollowingUser {
                                    if(!amIFollowingUser) {
                                        HStack {
                                            Circle()
                                                .foregroundColor(.primary)
                                                .frame(width:5, height: 5)
                                            
                                            Text("Follow")
                                                .font(.subheadline.weight(.medium))
                                                .foregroundColor(color.accentColor)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Text(item.profession)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 200 ,height: 50, alignment: .leading)
                }
            }
            
            Spacer()
            
            Button {
                myFollowersFollowingsListVM.actionSheetItemForFollowerFollowingListView = RemoveBlockUnblockFollowerActionSheetModel(
                    id: item.id,
                    removeBlockUnblockAction: {
                        myFollowersFollowingsListVM.isPresentedProgressView = true
                        
                        myFollowersFollowingsListVM.removeFollower(userUID: item.id) { status in
                            if(status) {
                                if let index = myFollowersFollowingsListVM.myFollowersDataArray.firstIndex(of:item) {
                                    myFollowersFollowingsListVM.myFollowersDataArray.remove(at: index)
                                }
                            } else {
                                myFollowersFollowingsListVM.isPresentedProgressView =  false
                            }
                        }
                    },
                    title: "Remove Follower?",
                    message: "Happening won't tell \(item.userName) they were removed from your followers.",
                    destructiveText: .remove
                )
            } label: {
                Text("Remove")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.secondary, lineWidth: 1)
                            .foregroundColor(.secondary)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onAppear {
            amIFollowingUser = item.amIFollowingUser
        }
    }
}
