//
//  BlockedUserItemView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-18.
//

import SwiftUI
import SDWebImageSwiftUI

struct BlockedUserItemView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var blockedUsersVM: BlockedUsersViewModel
    
    let item: BlockedUserModel?
    
    @State var isPresentedProgressView: Bool = false
    
    // MARK: BODY
    var body: some View {
        if let item = item {
            HStack {
                HStack {
                    WebImage(url: URL(string: item.profilePhotoThumbnailURL))
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                        }
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(item.userName)
                            .font(.subheadline)
                        
                        Text(item.about)
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text(item.profession)
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text(item.blockedDTCustom)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                .lineLimit(1)
                .frame(width: 250, alignment: .leading)
                
                Spacer()
                
                Button {
                    blockedUsersVM.actionSheetItemForBlockedUsersListView = RemoveBlockUnblockFollowerActionSheetModel(
                        id: item.id,
                        removeBlockUnblockAction: {
                            
                            isPresentedProgressView = true
                            
                            blockedUsersVM.unblockUser(userUID: item.id) { status in
                                if(status) {
                                    isPresentedProgressView = false
                                    
                                    print("Unblocked Successful")
                                    
                                } else {
                                    isPresentedProgressView = false
                                }
                            }
                        },
                        title: "Unblock \(item.userName)?",
                        message: "Happening won't tell \(item.userName) they were unblocked by you.",
                        destructiveText: .unblock)
                } label: {
                    HStack(spacing: 5) {
                        ProgressView()
                            .tint(.secondary)
                            .scaleEffect(0.8)
                            .opacity(isPresentedProgressView ? 1 : 0)
                        
                        Text("Unblock")
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
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .padding(.horizontal)
        } else {
            ProgressView()
                .tint(.secondary)
        }
    }
}

// MARK: PREVIEWS
//struct BlockedUserItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            BlockedUserItemView()
//                .preferredColorScheme(.dark)
//
//            BlockedUserItemView()
//        }
//    }
//}
