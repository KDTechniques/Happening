//
//  ParticipatorMessagesViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-10.
//

import Foundation
import Firebase

class ParticipatorMessagesViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = ParticipatorMessagesViewModel()
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // reference to CurrentUser
    let currentUser = CurrentUser.shared
    
    // reference to MessageSheetViewModel
    let messageSheetVM = MessageSheetViewModel.shared
    
    // controls the searching text of participator message notifications
    @Published var searchTextParticipatorMessages: String = "" {
        didSet {
            filterResults(participatorMessageText: searchTextParticipatorMessages)
            
            if searchTextParticipatorMessages.isEmpty {
                resetParticipatorMessagesProgress()
            }
        }
    }
    
    // state whether the user is searching something on message notifications
    @Published var isSearchingParticipatorMessages: Bool = false
    
    // store all the participator chat data
    @Published var participatorChatDataArray = [MessageAsAParticipatorModel]() {
        didSet {
            filteredParticipatorChatDataArray = participatorChatDataArray.sorted {
                $0.chatDataArray[$0.chatDataArray.count-1].sentTimeFull > $1.chatDataArray[$1.chatDataArray.count-1].sentTimeFull
            }
            
            if participatorChatDataArray.isEmpty {
                noMessagesForParticipatorMessages()
            } else {
                resetParticipatorMessagesProgress()
            }
        }
    }
    
    // store all the filtered participator chat data
    @Published var filteredParticipatorChatDataArray = [MessageAsAParticipatorModel]()
    
    // a firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    // controls the presentation of processing for Participator Messages
    @Published var showProgressViewForParticipatorMessages: Bool = false
    @Published var showNoResultsFoundForParticipatorMessages: Bool = false
    @Published var showNoMessagesForParticipatorMessages: Bool = false
    
    // present an alert item for ParticipatorMessageItemView
    @Published var alertItemForParticipatorMessageItemView: AlertItemModel?
    
    // an array that stores my happening doc ids
    @Published var myHappeningDocIDsArray = [String]()
    
    // MARK: INITIALIZERS
    init() {
        getMyHappeningDocIDs { _ in
            self.getMessagesAsAParticipator { status, participatorChatDataArray in
                if status == .success {
                    self.participatorChatDataArray = participatorChatDataArray
                    if participatorChatDataArray.isEmpty {
                        self.noMessagesForParticipatorMessages()
                    } else {
                        for item in participatorChatDataArray {
                            self.messageSheetVM.saveMessagesArrayToUserDefaults(array: item.chatDataArray)
                        }
                    }
                } else {
                    if participatorChatDataArray.isEmpty {
                        self.noMessagesForParticipatorMessages()
                    }
                }
            }
        }
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getMyHappeningDocIDs
    func getMyHappeningDocIDs(completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        guard let myuserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(.error)
            return
        }
        
        db
            .collection("Users/\(myuserUID)/HappeningData")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("either query snapshot nil or no documents available.")
                        completion(.error)
                        return
                    }
                    
                    self.myHappeningDocIDsArray.removeAll()
                    for document in querySnapshot.documents {
                        self.myHappeningDocIDsArray.append(document.documentID)
                    }
                    
                    print("My Happening Document IDs Have Been Filtered & Stored In An Array Successfully. 🤓🤓🤓")
                    print("Happening Doc IDs: \(self.myHappeningDocIDsArray as Any)")
                    completion(.success)
                }
            }
    }
    
    // MARK: getChatDataToFilterHappeningDocIDs
    func getChatDataToFilterHappeningDocIDs(completion: @escaping (_ status: AsyncFunctionStatusTypes, _ happeningDocIDsNCreatorUIDsArray: [HappeningDocIDNCreatorUIDModel]) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(.error, [])
            return
        }
        firestoreListener?.remove()
        firestoreListener = db
            .collection("Users/\(myUserUID)/ChatData")
            .addSnapshotListener { querySnapshot, error in
                print("Snapshot Listener Fired 🔥🔥🔥")
                if let error = error {
                    print("Error: \(error)")
                    completion(.error, [])
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("query snapshot nil or no documents available.")
                        completion(.error, [])
                        return
                    }
                    
                    var happeningDocIDsNCreatorUIDsArray = [HappeningDocIDNCreatorUIDModel]()
                    var  happeningDocIDsArray = [String]()
                    
                    for document in querySnapshot.documents {
                        let happeningDocID = document.get("HappeningDocID") as? String
                        let receiverUID = document.get("ReceiverUID") as? String
                        let senderUID = document.get("SenderUID") as? String
                        
                        guard
                            let happeningDocID = happeningDocID,
                            let receiverUID = receiverUID,
                            let senderUID = senderUID else {
                                print("either happeningDocID or receiverUID or senderUID nil.")
                                completion(.error, [])
                                return
                            }
                        
                        var creatorUID: String = ""
                        
                        if self.myHappeningDocIDsArray.contains(happeningDocID) {
                            creatorUID = myUserUID
                        } else {
                            if receiverUID != myUserUID {
                                creatorUID = receiverUID
                            } else {
                                creatorUID = senderUID
                            }
                        }
                        
                        if !happeningDocIDsArray.contains(happeningDocID) && creatorUID != myUserUID{
                            
                            happeningDocIDsArray.append(happeningDocID)
                            
                            let object = HappeningDocIDNCreatorUIDModel(happeningDocID: happeningDocID, creatorUID: creatorUID)
                            happeningDocIDsNCreatorUIDsArray.append(object)
                        }
                    }
                    
                    print("Happening Doc IDs have Been Filtered From Chats Successfully. ❤️❤️❤️")
                    completion(.success, happeningDocIDsNCreatorUIDsArray)
                }
            }
    }
    
    // MARK: getChatDataForAHappening
    func getChatDataForAHappening(happeningDocID: String, completion: @escaping (_ status: AsyncFunctionStatusTypes, _ chatDataArray: [MessageSheetContentModel]) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(.error, [])
            return
        }
        
        db
            .collection("Users/\(myUserUID)/ChatData")
            .whereField("HappeningDocID", isEqualTo: happeningDocID)
            .order(by: "SentTimeFull")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error, [])
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("either query snapshot nil or documents not available.")
                        completion(.error, [])
                        return
                    }
                    
                    var tempArray = [MessageSheetContentModel]()
                    
                    for document in querySnapshot.documents {
                        let data = document.data()
                        let object = MessageSheetContentModel(data: data)
                        
                        tempArray.append(object)
                    }
                    
                    print("Chat Data Set For A Purticular Happening Has Been Retrieved Sucessfully. ❤️❤️❤️")
                    completion(.success, tempArray)
                }
            }
    }
    
    // MARK: getMyFollowingsIDs
    func getMyFollowingsIDs(completion: @escaping (_ status: AsyncFunctionStatusTypes, _ followingIDsArray: [String]) -> ()) {
        
        guard let myUserUID  = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(.error, [])
            return
        }
        
        db
            .collection("Users/\(myUserUID)/FollowingsData")
            .whereField("isBlocked", isEqualTo: false)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error, [])
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("either query snapshot nil  or no documents available.")
                        completion(.error, [])
                        return
                    }
                    
                    var tempArray = [String]()
                    
                    for document in querySnapshot.documents {
                        tempArray.append(document.documentID)
                    }
                    
                    print("Following IDs Array Has Been Created Successfully. ❤️❤️❤️")
                    completion(.success, tempArray)
                }
            }
    }
    
    // MARK: getHappeningDataNProfileDataForAHappening
    func getHappeningDataNProfileDataForAHappening(creatorUID: String, happeningDocID: String, completion: @escaping (_ status: AsyncFunctionStatusTypes, _ happeningDataObject: HappeningItemModel?) -> ()) {
        
        db
            .collection("Users/\(creatorUID)/HappeningData")
            .document(happeningDocID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error, nil)
                    return
                } else {
                    guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                        print("either document snapshot nil or no data available.")
                        completion(.error, nil)
                        return
                    }
                    
                    let dataSet1  = documentSnapshot.data() // happening data set
                    
                    self.getMyFollowingsIDs { status, followingIDsArray in
                        if status == .success {
                            
                            var followingStatus: Bool = false
                            
                            for id in followingIDsArray {
                                if id == creatorUID {
                                    followingStatus = true
                                }
                            }
                            
                            self.db
                                .collection("Users/\(creatorUID)/ProfileData")
                                .document(creatorUID)
                                .getDocument { documentSnapshot, error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                        completion(.error, nil)
                                        return
                                    } else {
                                        
                                        guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                                            print("either document snapshot nil or no data available.")
                                            completion(.error, nil)
                                            return
                                        }
                                        
                                        let dataSet2 = documentSnapshot.data() // profile data set
                                        
                                        guard
                                            let dataSet1 = dataSet1,
                                            let dataSet2 = dataSet2 else {
                                                print("data set 1 or data set 2 nil.")
                                                completion(.error, nil)
                                                return
                                            }
                                        
                                        var mergedDataSet = dataSet1
                                        
                                        mergedDataSet.merge(dataSet2) {(current, _) in current}
                                        
                                        let object = HappeningItemModel(data: mergedDataSet, happeningDocID: happeningDocID, followingStatus: followingStatus)
                                        print("A Happening Data Set Has Been Retrieved Successfully. ❤️❤️❤️")
                                        completion(.success, object)
                                    }
                                }
                        } else {
                            print("error getting following ids array.")
                            completion(.error, nil)
                            return
                        }
                    }
                }
            }
    }
    
    // MARK: getMessagesAsAParticipator
    func getMessagesAsAParticipator(completion: @escaping (_ status: AsyncFunctionStatusTypes, _ participatorMessageDataArray: [MessageAsAParticipatorModel]) -> ()) {
        
        progressViewForParticipatorMessages()
        
        self.getChatDataToFilterHappeningDocIDs { status, happeningDocIDsNCreatorUIDsArray in
            if status == .success {
                for item in happeningDocIDsNCreatorUIDsArray {
                    self.db
                        .collection("Users/\(item.creatorUID)/HappeningData")
                        .document(item.happeningDocID)
                        .addSnapshotListener { documentSnapshot, error in
                            print("HappeningData Snapshot Listener Fired. 🔥🔥🔥")
                            if let error = error {
                                print("Errror: \(error.localizedDescription)")
                                completion(.error, [])
                                return
                            } else {
                                
                                guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                                    print("either document snapshot not available or document not exsist.")
                                    completion(.error, [])
                                    return
                                }
                                
                                self.getChatDataToFilterHappeningDocIDs { status, happeningDocIDsNCreatorUIDsArray in
                                    if status == .success {
                                        let group = DispatchGroup()
                                        
                                        var participatorMessageDataArray = [MessageAsAParticipatorModel]()
                                        
                                        for item in happeningDocIDsNCreatorUIDsArray {
                                            // get chat data first
                                            group.enter()
                                            self.getChatDataForAHappening(happeningDocID: item.happeningDocID) { status, chatDataArray in
                                                if status == .success {
                                                    let messageSheetContentModelObject = chatDataArray // chat data array object
                                                    
                                                    //  get happening data with profile data second
                                                    group.enter()
                                                    self.getHappeningDataNProfileDataForAHappening(creatorUID: item.creatorUID, happeningDocID: item.happeningDocID) { status, happeningDataObject in
                                                        if status == .success {
                                                            guard let happeningItemModelObject = happeningDataObject else  { // happening data with profile data object
                                                                print("happening data or profile data or both nil.")
                                                                completion(.error, [])
                                                                return
                                                            }
                                                            
                                                            let object = MessageAsAParticipatorModel(happeningItemModelObject: happeningItemModelObject, messageSheetContentModelObject: messageSheetContentModelObject)
                                                            
                                                            participatorMessageDataArray.append(object)
                                                            group.leave()
                                                        } else {
                                                            print("happening data or profile data or both nil.")
                                                            completion(.error, [])
                                                            return
                                                        }
                                                    }
                                                    group.leave()
                                                } else {
                                                    print("chat data  nil.")
                                                    completion(.error, [])
                                                    return
                                                }
                                            }
                                        }
                                        
                                        group.notify(queue: .main) {
                                            print("A MessageData Set With Happening &  Profile Data Has Been Retrieved Successfully. ❤️❤️❤️")
                                            completion(.success, participatorMessageDataArray)
                                        }
                                    } else {
                                        print("happening doc ids and creator uids array nil.")
                                        completion(.error, [])
                                        return
                                    }
                                }
                            }
                        }
                }
            } else {
                completion(.error, [])
            }
        }
    }
    
    // MARK: filterResults - messageText
    private func filterResults(participatorMessageText: String) {
        if(participatorMessageText.isEmpty) {
            filteredParticipatorChatDataArray = participatorChatDataArray.sorted {
                $0.chatDataArray[$0.chatDataArray.count-1].sentTimeFull > $1.chatDataArray[$1.chatDataArray.count-1].sentTimeFull
            }
        } else {
            filteredParticipatorChatDataArray = participatorChatDataArray.filter {
                $0.happeningDataWithProfileData.title.localizedCaseInsensitiveContains(participatorMessageText)
                ||
                $0.happeningDataWithProfileData.userName.localizedCaseInsensitiveContains(participatorMessageText)
                ||
                $0.happeningDataWithProfileData.ssdt.localizedCaseInsensitiveContains(participatorMessageText)
                ||
                $0.happeningDataWithProfileData.startingDateTime.localizedCaseInsensitiveContains(participatorMessageText)
                ||
                $0.happeningDataWithProfileData.spaceFee.localizedCaseInsensitiveContains(participatorMessageText)
                ||
                String($0.happeningDataWithProfileData.spaceFeeNo).localizedCaseInsensitiveContains(participatorMessageText)
                ||
                ($0.happeningDataWithProfileData.followingStatus
                 ? $0.happeningDataWithProfileData.address.localizedCaseInsensitiveContains(participatorMessageText)
                 : $0.happeningDataWithProfileData.secureAddress.localizedCaseInsensitiveContains(participatorMessageText))
            }
            
            if filteredParticipatorChatDataArray.isEmpty {
                noResultsFoundForParticipatorMessages()
            } else {
                resetParticipatorMessagesProgress()
            }
        }
    }
    
    // MARK: progressViewForParticipatorMessages
    func progressViewForParticipatorMessages() {
        showProgressViewForParticipatorMessages = true
        showNoResultsFoundForParticipatorMessages = false
        showNoMessagesForParticipatorMessages = false
    }
    
    // MARK: noResultsFoundForParticipatorMessages
    func noResultsFoundForParticipatorMessages() {
        showProgressViewForParticipatorMessages = false
        showNoResultsFoundForParticipatorMessages = true
        showNoMessagesForParticipatorMessages = false
    }
    
    // MARK: noMessagesForParticipatorMessages
    func noMessagesForParticipatorMessages() {
        showProgressViewForParticipatorMessages = false
        showNoResultsFoundForParticipatorMessages = false
        showNoMessagesForParticipatorMessages = true
    }
    
    // MARK: resetParticipatorMessagesProgress
    func resetParticipatorMessagesProgress() {
        showProgressViewForParticipatorMessages = false
        showNoResultsFoundForParticipatorMessages = false
        showNoMessagesForParticipatorMessages = false
    }
    
    // MARK: deleteAChatThread
    func deleteAChatThread(happeningDocID: String) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my useruid nil.")
            return
        }
        
        var tempItem: MessageAsAParticipatorModel?
        
        if let index = participatorChatDataArray.firstIndex(where: { $0.happeningDataWithProfileData.id == happeningDocID }) {
            tempItem = participatorChatDataArray[index]
            participatorChatDataArray.remove(at: index)
        } else {
            print("error getting the an index in filteredParticipatorChatDataArray.")
        }
        
        db
            .collection("Users/\(myUserUID)/ChatData")
            .whereField("HappeningDocID", isEqualTo: happeningDocID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    if tempItem != nil {
                        self.filteredParticipatorChatDataArray.append(tempItem!)
                        print("Append from error closure")
                    }
                    self.alertItemForParticipatorMessageItemView = AlertItemModel(
                        title: "Unable to Delete",
                        message: "Couldn't delete \(tempItem != nil ? "'\(tempItem!.happeningDataWithProfileData.title)' " : "")Messages. Please try again later."
                    )
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty  else {
                        print("either querysnapshot nil or no documents available.")
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        document.reference.delete()
                    }
                    
                    print("Chat Thread Has Been Deleted From Participators Side Successfully. ❤️❤️❤️")
                }
            }
    }
}
