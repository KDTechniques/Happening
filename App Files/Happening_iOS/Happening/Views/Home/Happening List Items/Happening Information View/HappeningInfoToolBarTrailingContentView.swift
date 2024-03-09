//
//  HappeningInfoToolBarTrailingContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import SwiftUI

struct HappeningInfoToolBarTrailingContentView: View {
    
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
        if isFollowing {
            HStack {
                Button {
                    isPresentedMessageSheet = true
                    
                    messageSheetVM.getChatDataFromFirestore(
                        happeningDocID: happeningDocID) { status in
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
                        .font(.headline.weight(.semibold))
                }
                
                Button {
                    isPresentedPhoneActionSheet.toggle()
                } label: {
                    Image(systemName: "phone")
                        .font(.headline.weight(.semibold))
                }
            }
            .padding(.bottom, 5)
            .onChange(of: messageSheetVM.AllOfMyChatDataArray) { _ in
                chatDataArray = messageSheetVM.AllOfMyChatDataArray.filter { $0.happeningDocID == happeningDocID }
            }
        }
    }
}
