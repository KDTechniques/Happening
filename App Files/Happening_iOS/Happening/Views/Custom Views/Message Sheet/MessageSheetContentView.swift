//
//  MessageSheetContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-04.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreMedia
import DebouncedOnChange

struct MessageSheetContentView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var currentUser: CurrentUser
    @EnvironmentObject var messageSheetVM: MessageSheetViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    @Binding var chatDataArrayItem: [MessageSheetContentModel]
    
    let profilePhotoThumURL: String
    let happeningDocID: String
    let happeningTitle: String
    let receiverUID: String
    let receiverName: String
    
    @State private var textFieldText: String = ""
    
    @State private var isEnabled: Bool = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var messageFlagRegisterArray = [String]()
    
    @State private var alertItemForMessageSheetContentView: AlertItemModel?
    
    @State private var selectedItem: MessageSheetContentModel = MessageSheetContentModel(data: [:])
    
    @State private var amITyping: Bool = false
    
    @State private var isTyping: Bool = false
    
    // MARK: BODY
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: 100, height: 4)
                    .cornerRadius(.infinity)
                    .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Messages")
                        .font(.largeTitle.weight(.bold))
                    
                    Text(happeningTitle)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top, 6)
                    
                    Text(isTyping ? "\(receiverName) is typing..." : "\(receiverName), You")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading])
                
                Divider()
                
                if chatDataArrayItem.isEmpty {
                    VStack {
                        Text("Start a new conversation.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.top, 50)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                } else {
                    ScrollViewReader { proxy in
                        List(chatDataArrayItem) { item in
                            if let myUserUID = currentUser.currentUserUID {
                                
                                if myUserUID == item.senderUID {
                                    SendersTextMessageView(
                                        msgText: item.msgText,
                                        time: item.sentTime,
                                        isSent: item.isSent,
                                        isDelivered: item.isDelivered,
                                        isRead: item.isRead,
                                        reaction: item.reaction
                                    ).id(chatDataArrayItem.lastIndex(of: item)) // secure than 'firstIndex' when trying to scroll to an anchor
                                    
                                } else { // myUserUID != item.senderUID
                                    
                                    RecieversTextMessageView(
                                        profilePhotoThumbnailURL: profilePhotoThumURL,
                                        msgText: item.msgText,
                                        time: item.sentTime,
                                        reaction: item.reaction
                                    ).id(chatDataArrayItem.lastIndex(of: item)) // secure than 'firstIndex' when trying to scroll to an anchor
                                        .onAppear {
                                            if !item.isUpdated && !messageFlagRegisterArray.contains(item.chatDocID) {
                                                messageFlagRegisterArray.append(item.chatDocID)
                                                
                                                messageSheetVM.setMessageFlags(
                                                    chatDocID: item.chatDocID,
                                                    creatorsUID: item.senderUID,
                                                    flagType: .isRead) {
                                                        if $0 == .error {
                                                            print("Error Flagging \(item.msgText). 🚫🚫🚫")
                                                            self.messageFlagRegisterArray.removeAll(where: { $0 == item.chatDocID })
                                                        }
                                                    }
                                            }
                                        }
                                        .onTapGesture { }
                                        .onLongPressGesture(minimumDuration: 0.1) {
                                            hideKeyboard()
                                            
                                            selectedItem = item
                                            vibrate(type: .popup)
                                            
                                            withAnimation(.easeInOut(duration: 0.1)) {
                                                messageSheetVM.startAnimation = true
                                            }
                                        }
                                }
                            } else {
                                Text("Something went wrong. Please try again later.")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 50)
                            }
                        }
                        .listStyle(.plain)
                        .refreshable { }
                        .onTapGesture {
                            hideKeyboard()
                            
                            withAnimation(.easeInOut(duration: 0.1)) {
                                messageSheetVM.startAnimation = false
                            }
                        }
                        .onAppear {
                            scrollToBottom(proxy: proxy, showAnimation: false)
                        }
                        .onChange(of: chatDataArrayItem) { _ in
                            scrollToBottom(proxy: proxy, showAnimation: true)
                        }
                        .onChange(of: isTextFieldFocused) { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                scrollToBottom(proxy: proxy, showAnimation: true)
                            }
                        }
                        .onChange(of: textFieldText) { _ in
                            if receiverUID != "" {
                                if !amITyping {
                                    print("Typing...")
                                    amITyping = true
                                    
                                    messageSheetVM.setIsTypingMessageFlag(
                                        happeningDocID: happeningDocID,
                                        user2UID: receiverUID,
                                        isTyping: true) { _ in }
                                }
                            }
                        }
                        .onChange(of: textFieldText, debounceTime: 3) { _ in
                            if receiverUID != "" {
                                print("Not Typing")
                                amITyping = false
                                
                                messageSheetVM.setIsTypingMessageFlag(
                                    happeningDocID: happeningDocID,
                                    user2UID: receiverUID,
                                    isTyping: false) { _ in }
                            }
                        }
                        .onChange(of: messageSheetVM.isTypingDataArray) { newValue in
                            if let item = newValue.first(where: { $0.happeningDocID == happeningDocID && $0.typingUserUID == receiverUID }) {
                                isTyping = item.isTyping
                            } else {
                                isTyping = false
                            }
                        }
                    }
                }
                
                MessegeTextFieldBarView(
                    textFieldText: $textFieldText,
                    isEnabled: $isEnabled,
                    placeholder: "",
                    textFieldBackgroundColor: .constant(Color("MessageTextFieldColor")),
                    fullBackgroundColor: .constant(Color("NavBarTabBarColor")),
                    dividerOpacity: 1,
                    textForegroundColor: .primary,
                    textFieldVerticalPadding: 5,
                    buttonHeight: .constant(32),
                    buttonColor1: .constant(.white),
                    buttonColor2: .constant(.white),
                    buttonColor3: .constant(.black),
                    isAlwaysEnabled: false,
                    specialBlackCondition: .constant(false)) {
                        // send button action starts below...
                        
                        if networkManager.connectionStatus == .connected {
                            messageSheetVM.sendAMessage(
                                happeningDocID: happeningDocID,
                                happeningTitle: happeningTitle,
                                receiverUID: receiverUID,
                                msgText: textFieldText,
                                pendingChatDocID: nil,
                                pendingSentTime: nil,
                                pendingSentTimeFull: nil) {
                                    if $0 == .success {
                                        SoundManager.shared.playSound(sound: .msgSent)
                                    }
                                }
                            
                            /// clear text field text after calling 'sendAMessage' function
                            textFieldText.removeAll()
                        } else {
                            alertItemForMessageSheetContentView = AlertItemModel(
                                title: "Couldn't Send Message",
                                message: "Check your phone's connection and try again.",
                                dismissButton: .cancel(Text("OK"))
                            )
                        }
                    }
                    .focused($isTextFieldFocused)
            }
            .blur(radius: messageSheetVM.startAnimation ? 10 : 0)
            .alert(item: $alertItemForMessageSheetContentView) { alert -> Alert in
                Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
            }
            
            if messageSheetVM.startAnimation {
                EmojiButtonsView(
                    selectedEmoji: selectedItem.reaction,
                    profilePhotoThumbnailURL: profilePhotoThumURL,
                    msgText: selectedItem.msgText,
                    sentTime: selectedItem.sentTime,
                    item: selectedItem
                )
            }
        }
        .onAppear {
            messageSheetVM.getIsTypingChatDataFromFirestore { _ in }
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy, showAnimation: Bool) {
        if showAnimation {
            withAnimation(.spring()) {
                let lastIndex = chatDataArrayItem.count - 1
                proxy.scrollTo(lastIndex, anchor: .bottom)
            }
        } else {
            let lastIndex = chatDataArrayItem.count - 1
            proxy.scrollTo(lastIndex, anchor: .bottom)
        }
    }
}
