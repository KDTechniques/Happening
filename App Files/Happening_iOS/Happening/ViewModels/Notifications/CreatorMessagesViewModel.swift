//
//  CreatorMessagesViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-10.
//

import Foundation
import Firebase

class CreatorMessagesViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = CreatorMessagesViewModel()
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // reference to CurrentUser
    let currentUser = CurrentUser.shared
    
    // reference to MessageSheetViewModel
    let messageSheetVM = MessageSheetViewModel.shared
    
    // controls the searching text of creator message notifications
    @Published var searchTextCreatorMessages: String = "" {
        didSet {
            filterResults(text: searchTextCreatorMessages)
            
            if searchTextCreatorMessages.isEmpty {
                resetCreatorMessagesProgress()
            }
        }
    }
    
    // state whether the user is searching something on message notifications
    @Published var isSearchingCreatorMessages: Bool = false
    
    // a firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    var firestoreListener2: ListenerRegistration?
    
    // store all the current happenning chat data in this array
    @Published var messagesAsACreatorChatDataArray = [MessageAsACreatorModel]() {
        didSet {
            sortedMessagesAsACreatorChatDataArray = messagesAsACreatorChatDataArray.sorted {
                $0.chatData[$0.chatData.count-1].sentTimeFull > $1.chatData[$1.chatData.count-1].sentTimeFull
            }
            
            if messagesAsACreatorChatDataArray.isEmpty {
                noMessagesForCreatorMessages()
            } else {
                resetCreatorMessagesProgress()
            }
        }
    }
    
    // store all sorted the current happening chat data in this array
    @Published var sortedMessagesAsACreatorChatDataArray = [MessageAsACreatorModel]()
    
    // present a sheet item for CreatorMessagesListItemsView
    @Published var sheetItemForCreatorMessagesListItemsView: MessageAsACreatorModel?
    
    @Published private var messageFlagRegisterArray = [String]()
    
    // controls the presentation of processing for Creator Messages
    @Published var showProgressViewForCreatorMessages: Bool = false
    @Published var showNoResultsFoundForCreatorMessages: Bool = false
    @Published var showNoMessagesForCreatorMessages: Bool = false
    
    // MARK: INITIALIZER
    init() {
        progressViewForCreatorMessages()
        
        filterNSortChatData { status, filteredNSortedChatDataArray in
            if status == .success {
                self.resetCreatorMessagesProgress()
                self.messagesAsACreatorChatDataArray = filteredNSortedChatDataArray
            } else {
                self.noMessagesForCreatorMessages()
                print("No messsages available at the moment.")
            }
        }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: getAllCurrentHappeningChatData
    private func getAllCurrentHappeningChatData(completion: @escaping (_ status: AsyncFunctionStatusTypes, _ chatDataArray: [MessageSheetContentModel], _ happeningDocIDsArray: [String]) -> ()) {
        
        guard let myuserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(.error, [], [])
            return
        }
        
        firestoreListener2?.remove()
        firestoreListener2 = db
            .collection("Users/\(myuserUID)/HappeningData")
            .whereField("DueFlag", isEqualTo: "live")
            .addSnapshotListener { querySnapshot, error in
                print("Snapshot Listener Just Fired For My Live Happenings. 🔥🔥🔥")
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error, [], [])
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("either query snapshot nil or no documents available.")
                        completion(.error, [], [])
                        return
                    }
                    
                    var tempArray = [String]()
                    for documents in querySnapshot.documents {
                        tempArray.append(documents.documentID)
                    }
                    
                    /// remove below for loop after testing
                    for id in tempArray {
                        print("Current Happening ID: \(id)")
                    }
                    print("Current Happening Doc IDs Array Has Been Created Successfully. ❤️❤️❤️")
                    
                    self.firestoreListener?.remove()
                    self.firestoreListener = self.db
                        .collection("Users/\(myuserUID)/ChatData")
                        .whereField("HappeningDocID", in: tempArray)
                        .order(by: "SentTimeFull")
                        .addSnapshotListener { querySnapshot, error in
                            if let error = error {
                                print("Errror: \(error.localizedDescription)")
                                completion(.error, [], [])
                                return
                            } else {
                                
                                guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                                    print("either querysnapshot nil or no documents available.")
                                    completion(.error, [], [])
                                    return
                                }
                                
                                var tempArray2 = [MessageSheetContentModel]()
                                for document in querySnapshot.documents {
                                    let data = document.data()
                                    let object = MessageSheetContentModel(data: data)
                                    
                                    tempArray2.append(object)
                                }
                                
                                if tempArray2[tempArray2.count-1].senderUID != myuserUID
                                    && !tempArray2[tempArray2.count-1].isUpdated
                                    && !self.messageFlagRegisterArray.contains(tempArray2[tempArray2.count-1].chatDocID) {
                                    
                                    self.messageFlagRegisterArray.append(tempArray2[tempArray2.count-1].chatDocID)
                                    
                                    MessageSheetViewModel.shared.setMessageFlags(
                                        chatDocID: tempArray2[tempArray2.count-1].chatDocID,
                                        creatorsUID: tempArray2[tempArray2.count-1].senderUID,
                                        flagType: .isDelivered) { _ in }
                                }
                                
                                print("Current Happenings Chat Data Array Has Been Created Successfully. ❤️❤️❤️")
                                self.messageSheetVM.saveMessagesArrayToUserDefaults(array: tempArray2)
                                completion(.success, tempArray2, tempArray)
                            }
                        }
                }
            }
    }
    
    // MARK: filterNSortChatData
    private func filterNSortChatData(completion: @escaping (_ status: AsyncFunctionStatusTypes, _ filteredNSortedChatDataArray: [MessageAsACreatorModel]) -> ()) {
        
        guard let myuserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(.error, [])
            return
        }
        
        var tempUserIDsArray = [String]() /// store user ids in this array
        getAllCurrentHappeningChatData { status, chatDataArray, happeningDocIDsArray in
            if status == .success {
                for item in chatDataArray {
                    if item.senderUID != myuserUID {
                        if !tempUserIDsArray.contains(item.senderUID) {
                            tempUserIDsArray.append(item.senderUID)
                        }
                    } else if item.receiverUID != myuserUID {
                        if !tempUserIDsArray.contains(item.receiverUID) {
                            tempUserIDsArray.append(item.receiverUID)
                        }
                    }
                }
                
                print("User IDs Have Been Filtered & An Array Has Been Created Successfully. ❤️❤️❤️")
                
                var tempChatDataArray = [MessageAsACreatorModel]()
                
                let group = DispatchGroup()
                
                for userUID in tempUserIDsArray {
                    group.enter()
                    self.db
                        .collection("Users/\(userUID)/ProfileData")
                        .document(userUID)
                        .getDocument { documentSnapshot, error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                completion(.error, [])
                                return
                            } else {
                                guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                                    print("either document snapshot nil or document not available.")
                                    completion(.error, [])
                                    return
                                }
                                
                                let userName = documentSnapshot.get("UserName") as? String
                                let profilePhotoThumbnailURL = documentSnapshot.get("ProfilePhotoThumbnail") as? String
                                
                                guard
                                    let userName = userName,
                                    let profilePhotoThumbnailURL = profilePhotoThumbnailURL else {
                                        print("either user name or profile photo thumbnail nil.")
                                        completion(.error, [])
                                        return
                                    }
                                
                                for happeningDocID in  happeningDocIDsArray {
                                    let object = MessageAsACreatorModel(
                                        happeningDocID: happeningDocID,
                                        chatData: chatDataArray.filter { ($0.receiverUID == userUID || $0.senderUID == userUID) && $0.happeningDocID == happeningDocID },
                                        userName: userName,
                                        profilePhotoThumbnailURL: profilePhotoThumbnailURL
                                    )
                                    
                                    if !chatDataArray.filter ({ ($0.receiverUID == userUID || $0.senderUID == userUID) && $0.happeningDocID == happeningDocID }).isEmpty {
                                        tempChatDataArray.append(object)
                                    }
                                }
                                
                                group.leave()
                            }
                        }
                }
                
                group.notify(queue: .main) {
                    print("Messages As A Creator Messages Data Array Has Been Created Successfully. 👍🏻👍🏻👍🏻")
                    completion(.success, tempChatDataArray)
                }
            } else {
                completion(.error, [])
            }
        }
    }
    
    // MARK: filterResults
    private func filterResults(text: String) {
        if(text.isEmpty) {
            sortedMessagesAsACreatorChatDataArray = messagesAsACreatorChatDataArray
        } else {
            sortedMessagesAsACreatorChatDataArray = messagesAsACreatorChatDataArray.filter {
                $0.userName.localizedCaseInsensitiveContains(text)
                ||
                $0.happeningTitle.localizedCaseInsensitiveContains(text)
                ||
                $0.chatData[$0.chatData.count-1].msgText.localizedCaseInsensitiveContains(text)
            }
            
            if sortedMessagesAsACreatorChatDataArray.isEmpty {
                noResultsFoundForCreatorMessages()
            } else {
                resetCreatorMessagesProgress()
            }
        }
    }
    
    // MARK: progressViewForCreatorMessages
    func progressViewForCreatorMessages() {
        showProgressViewForCreatorMessages = true
        showNoResultsFoundForCreatorMessages = false
        showNoMessagesForCreatorMessages = false
    }
    
    // MARK: noResultsFoundForCreatorMessages
    func noResultsFoundForCreatorMessages() {
        showProgressViewForCreatorMessages = false
        showNoResultsFoundForCreatorMessages = true
        showNoMessagesForCreatorMessages = false
    }
    
    // MARK: noMessagesForCreatorMessages
    func noMessagesForCreatorMessages() {
        showProgressViewForCreatorMessages = false
        showNoResultsFoundForCreatorMessages = false
        showNoMessagesForCreatorMessages = true
    }
    
    // MARK: resetParticipatorCreatorMessages
    func resetCreatorMessagesProgress() {
        showProgressViewForCreatorMessages = false
        showNoResultsFoundForCreatorMessages = false
        showNoMessagesForCreatorMessages = false
    }
}
