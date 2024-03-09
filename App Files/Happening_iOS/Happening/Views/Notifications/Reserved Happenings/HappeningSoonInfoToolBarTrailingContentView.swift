//
//  HappeningSoonInfoToolBarTrailingContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-03.
//

import SwiftUI

struct HappeningSoonInfoToolBarTrailingContentView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var messageSheetVM: MessageSheetViewModel
    @EnvironmentObject var happeningVM: HappeningsViewModel
    
    @Binding var isPresentedPhoneActionSheet: Bool
    @Binding var isPresentedMessageSheet: Bool
    
    @Binding var chatDataArray: [MessageSheetContentModel]
    
    let isFollowing: Bool
    let happeningDocID: String
    
    // MARK: BODY
    var body: some View {
        HStack {
            Button {
                isPresentedMessageSheet = true
                
                messageSheetVM.getChatDataFromFirestore(happeningDocID: happeningDocID) { status in
                    if status == .error {
                        isPresentedMessageSheet = false
                        happeningVM.alertItemForHappeningInformationView = AlertItemModel(
                            title: "Unable To Load The Chat",
                            message: "Something went wrong. Please try again later."
                        )
                    } else {
                        self.chatDataArray = messageSheetVM.AllOfMyChatDataArray.filter { $0.happeningDocID == happeningDocID }
                    }
                }
            } label: {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.title2.weight(.medium))
            }
            .padding(.trailing, 10)
            
            Button {
                isPresentedPhoneActionSheet.toggle()
            } label: {
                Image(systemName: "phone")
                    .font(.title2.weight(.semibold))
            }
        }
        .onChange(of: messageSheetVM.AllOfMyChatDataArray) { _ in
            chatDataArray = messageSheetVM.AllOfMyChatDataArray.filter { $0.happeningDocID == happeningDocID }
        }
    }
}
