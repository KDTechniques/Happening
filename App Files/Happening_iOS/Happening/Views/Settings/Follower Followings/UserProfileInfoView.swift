//
//  UserProfileInfoView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-17.
//

import SwiftUI

struct UserProfileInfoView: View {
    
    // MARK: PROPERTIES
    @Environment(\.dismiss) var presentationMode
    @EnvironmentObject var myfollowerFollowingsVM: MyFollowersFollowingsListViewModel
    @EnvironmentObject var publicProfileInfoVM: PublicProfileInfoViewModel
    @EnvironmentObject var userProfileInfoVM: UserProfileInfoViewModel
    
    let type: MyFollowersFollowingsListViewModel.followerFollowingSelectionTypes
    let userUID: String
    
    // MARK: BODY
    var body: some View {
        ZStack {
            if let data = userProfileInfoVM.data {
                PublicProfileInfoView(item: data)
            } else {
                ProgressView()
                    .tint(.secondary)
            }
        }
        .onAppear {
            myfollowerFollowingsVM.followerFollowingSelectionCoordinator = type
            
            publicProfileInfoVM.getPublicProfileInfoFromUserUID(userUID: userUID) { status in
                if(status) {
                    userProfileInfoVM.data = publicProfileInfoVM.publicProfileInfoDataObject
                } else {
                    userProfileInfoVM.alertItemForUserProfileInfoView = AlertItemModel(
                        title: "Something Went Wrong",
                        message: "Please try again in a moment.",
                        dismissButton: .cancel(Text("Go Back")) {
                            presentationMode.callAsFunction()
                        }
                    )
                }
            }
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 4) {
                DispatchQueue.main.async {
                    if(userProfileInfoVM.data == nil) {
                        userProfileInfoVM.alertItemForUserProfileInfoView = AlertItemModel(
                            title: "Something Went Wrong",
                            message: "Please try again in a moment.",
                            dismissButton: .cancel(Text("Go Back")) {
                                presentationMode.callAsFunction()
                            }
                        )
                    }
                }
            }
        }
        .onDisappear {
            userProfileInfoVM.data = nil
        }
        .alert(item: $userProfileInfoVM.alertItemForUserProfileInfoView) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: alert.dismissButton
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Profile Info")
                    .fontWeight(.semibold)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Block") {
                    myfollowerFollowingsVM.actionSheetItemForFollowerFollowingListView = RemoveBlockUnblockFollowerActionSheetModel(
                        id: userProfileInfoVM.data?.id ?? UUID().uuidString,
                        removeBlockUnblockAction: {
                            
                            guard let data = userProfileInfoVM.data else {
                                userProfileInfoVM.alertItemForUserProfileInfoView = AlertItemModel(
                                    title: "Unable to Block",
                                    message: "Please try again in a moment."
                                )
                                return
                            }
                            
                            presentationMode.callAsFunction()
                            
                            myfollowerFollowingsVM.blockUser(userUID: data.id) { _ in }
                        },
                        title: "Block \(userProfileInfoVM.data?.userName ?? "This User")?",
                        message: "Happening won't tell \(userProfileInfoVM.data?.userName ?? "This User") they were blocked by you.",
                        destructiveText: .block
                    )
                }
                .foregroundColor(.red)
                .opacity(userProfileInfoVM.data == nil ? 0 : 1)
            }
        }
        .actionSheet(item: $userProfileInfoVM.actionSheetItemForUserProfileInfoView) { item in
            ActionSheet(
                title: Text(item.title),
                message: Text(item.message),
                buttons: [.destructive(Text(item.destructiveText.rawValue)){ item.removeBlockUnblockAction() }, .cancel()]
            )
        }
    }
}

// MARK: PREVIEWS
struct UserProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserProfileInfoView(type: .followers, userUID: "")
                .preferredColorScheme(.dark)
            
            UserProfileInfoView(type: .followers, userUID: "")
        }
        .environmentObject(MyFollowersFollowingsListViewModel())
        .environmentObject(PublicProfileInfoViewModel())
        .environmentObject(UserProfileInfoViewModel())
    }
}
