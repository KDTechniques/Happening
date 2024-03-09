//
//  FollowingsItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowingsItemView: View {
    
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var myfollowerFollowingsVM: MyFollowersFollowingsListViewModel
    @EnvironmentObject var currentUser: CurrentUser
    @EnvironmentObject var publicProfileInfoVM: PublicProfileInfoViewModel
    
    let item: MyFollowingsModel
    
    @State private var count: Int = 0
    
    var body: some View {
        HStack {
            NavigationLink {
                UserProfileInfoView(type: .followings, userUID: item.id)
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
                        Text(item.userName)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.primary)
                        
                        Text(item.profession)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 150 ,height: 50, alignment: .leading)
                }
            }
            
            Spacer()
            
            ProgressView()
                .tint(.secondary)
                .scaleEffect(0.8)
                .opacity(0)
            
            Spacer()
            
            Button {
                guard let myUserUID = currentUser.currentUserUID else {
                    myfollowerFollowingsVM.alertItemForFollowerFollowingListView = AlertItemModel(
                        title: "Unable To \(count % 2 == 0 ? "Follow" : "Unfollow")",
                        message: "Something went wrong. Please try again later."
                    )
                    return
                }
                myfollowerFollowingsVM.isPresentedProgressView = true
                
                if(count % 2 == 0) {
                    myfollowerFollowingsVM.unfollowUser(myUserUID: myUserUID, userUID: item.id) { status in
                        if(status) {
                            count += 1
                        } else {
                            myfollowerFollowingsVM.isPresentedProgressView = false
                        }
                    }
                } else {
                    myfollowerFollowingsVM.followUser(myUserUID: myUserUID, userUID: item.id) { status in
                        if(status) {
                            count += 1
                        } else {
                            myfollowerFollowingsVM.isPresentedProgressView = false
                        }
                    }
                }
            } label: {
                Text(count % 2 == 0 ? "Following" : "Follow")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(count % 2 == 0 ? .primary : .white)
                    .frame(width: 100)
                    .padding(.vertical, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.secondary, lineWidth: 1)
                            .foregroundColor(.secondary)
                            .opacity(count % 2 == 0 ? 1 : 0)
                    )
                    .background(color.accentColor.opacity(count % 2 == 0 ? 0 : 1))
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct FollowingsItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FollowingsItemView(item: MyFollowingsModel(dataSet: ["":""], docID: ""))
                .preferredColorScheme(.dark)
            
            FollowingsItemView(item: MyFollowingsModel(dataSet: ["":""], docID: ""))
        }
        .environmentObject(MyFollowersFollowingsListViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(CurrentUser())
        .environmentObject(PublicProfileInfoViewModel())
    }
}
