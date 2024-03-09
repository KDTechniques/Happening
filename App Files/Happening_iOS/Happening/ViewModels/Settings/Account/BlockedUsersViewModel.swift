//
//  BlockedUsersViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-18.
//

import Foundation
import Firebase

class BlockedUsersViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = BlockedUsersViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // controls the blocked users count
    @Published var numberOfBlockedUsers = 0
    
    // present an alert item for BlockedUsersView
    @Published var alertItemForBlockedUsersView: AlertItemModel?
    
    // an array of blocked users data that conforms to BlockedUserModel
    @Published var blockedUsersDataArray = [BlockedUserModel]() {
        didSet {
            orderedBlockedItemsArray = blockedUsersDataArray
            
            updateOrderedArray(type: blockUsersSortingSelection)
        }
    }
    
    // store all of the ordered blocked users items in this array that confirms to BlockedUserModel
    @Published var orderedBlockedItemsArray = [BlockedUserModel]()
    
    // present an action sheet item for BlockedUsersListView
    @Published var actionSheetItemForBlockedUsersListView: RemoveBlockUnblockFollowerActionSheetModel?
    
    // controls the sorting type of the block users list view
    @Published var blockUsersSortingSelection: blockUsersSortingTypes = .blockedLatest {
        didSet {
            updateOrderedArray(type: blockUsersSortingSelection)
        }
    }
    
    // provide sorting types to sort block users items in the list
    enum blockUsersSortingTypes {
        case blockedLatest
        case blockEarliest
    }
    
    // controls the searching text of the block user items list
    @Published var blockedUsersSearchingText: String = "" {
        didSet {
            if(blockedUsersSearchingText.isEmpty) {
                updateOrderedArray(type: blockUsersSortingSelection)
            } else {
                filterBlockResults(text: blockedUsersSearchingText)
            }
        }
    }
    
    // state whether the user is searching a blocked user or not
    @Published var isSearchingBlockedUser: Bool = false
    
    // present an alert item for BlockUserItemView
    @Published var alertItemForBlockUserItemView: AlertItemModel?
    
    // MARK: FUNCTIONS
    
    
    // MARK: getBlockedUsersFromFirestore
    func getBlockedUsersFromFirestore(completion: @escaping (_  status: Bool) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            completion(false)
            return
        }
        
        var documentIDArray = [String]()
        
        blockedUsersDataArray.removeAll()
        
        // 1. get documents from followers data
        db
            .collection("Users/\(myUserUID)/FollowersData")
            .whereField("Blockedby", isEqualTo: myUserUID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                } else {
                    guard let querySnapshot = querySnapshot else {
                        completion(false)
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        
                        if(!documentIDArray.contains(document.documentID)) {
                            
                            documentIDArray.append(document.documentID)
                            
                            var dataSet1: [String:Any]?
                            
                            let userUID = document.documentID
                            dataSet1 = document.data()
                            
                            self.db
                                .collection("Users/\(userUID)/ProfileData")
                                .document(userUID)
                                .getDocument { documentSnapshot, error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                        completion(false)
                                        return
                                    } else {
                                        
                                        guard let documentSnapshot = documentSnapshot else {
                                            completion(false)
                                            return
                                        }
                                        
                                        var dataSet2: [String:Any]?
                                        if(documentSnapshot.exists) {
                                            dataSet2 = documentSnapshot.data()
                                        } else {
                                            completion(false)
                                            return
                                        }
                                        
                                        guard
                                            let dataSet1 = dataSet1,
                                            let dataSet2 = dataSet2 else {
                                                completion(false)
                                                return
                                            }
                                        
                                        var mergedDataSet = dataSet1
                                        
                                        mergedDataSet.merge(dataSet2) {(current, _) in current}
                                        
                                        let object = BlockedUserModel(data: mergedDataSet, userUID: userUID)
                                        self.blockedUsersDataArray.append(object)
                                    }
                                }
                        }
                    }
                    
                    // 2. get documents from followings data
                    self.db
                        .collection("Users/\(myUserUID)/FollowingsData")
                        .whereField("Blockedby", isEqualTo: myUserUID)
                        .getDocuments { querySnapshot, error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                completion(false)
                                return
                            } else {
                                guard let querySnapshot = querySnapshot else {
                                    completion(false)
                                    return
                                }
                                
                                for document in querySnapshot.documents {
                                    
                                    if(!documentIDArray.contains(document.documentID)) {
                                        
                                        documentIDArray.append(document.documentID)
                                        
                                        var dataSet1: [String:Any]?
                                        
                                        let userUID = document.documentID
                                        dataSet1 = document.data()
                                        
                                        self.db
                                            .collection("Users/\(userUID)/ProfileData")
                                            .document(userUID)
                                            .getDocument { documentSnapshot, error in
                                                if let error = error {
                                                    print("Error: \(error.localizedDescription)")
                                                    completion(false)
                                                    return
                                                } else {
                                                    
                                                    guard let documentSnapshot = documentSnapshot else {
                                                        completion(false)
                                                        return
                                                    }
                                                    
                                                    var dataSet2: [String:Any]?
                                                    
                                                    if(documentSnapshot.exists) {
                                                        dataSet2 = documentSnapshot.data()
                                                    } else {
                                                        completion(false)
                                                        return
                                                    }
                                                    
                                                    guard
                                                        let dataSet1 = dataSet1,
                                                        let dataSet2 = dataSet2 else {
                                                            completion(false)
                                                            return
                                                        }
                                                    
                                                    var mergedDataSet = dataSet1
                                                    
                                                    mergedDataSet.merge(dataSet2) {(current, _) in current}
                                                    
                                                    let object = BlockedUserModel(data: mergedDataSet, userUID: userUID)
                                                    self.blockedUsersDataArray.append(object)
                                                }
                                            }
                                    }
                                }
                                
                                self.numberOfBlockedUsers = documentIDArray.count
                                print("Blocked Users Data Has Been Retrieved Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                                completion(true)
                            }
                        }
                }
            }
    }
    
    // MARK: filterBlockResults
    func filterBlockResults(text: String) {
        if(text.isEmpty) {
            orderedBlockedItemsArray = blockedUsersDataArray
        } else {
            orderedBlockedItemsArray  =  blockedUsersDataArray.filter { $0.userName.localizedCaseInsensitiveContains(text) }
        }
    }
    
    // MARK: updateOrderedArray
    func updateOrderedArray(type: blockUsersSortingTypes) {
        if(type == .blockEarliest) {
            orderedBlockedItemsArray = blockedUsersDataArray.sorted { $0.blockedDT < $1.blockedDT} // should be - to +
        } else {
            orderedBlockedItemsArray = blockedUsersDataArray.sorted { $0.blockedDT > $1.blockedDT} // should be + to -
        }
    }
    
    // MARK: unblockUser
    func unblockUser(userUID: String, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            alertItemForBlockUserItemView = AlertItemModel(
                title: "Unable To Unblock",
                message: "Something went wrong. Please try again later."
            )
            completion(false)
            return
        }
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "myDocID": myUserUID,
            "userDocID": userUID,
            "collectionName": "Users",
            "followersSubCName": "FollowersData",
            "followingSubCName": "FollowingsData"
        ]
        
        functions.httpsCallable("unblockUser").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                self.alertItemForBlockUserItemView = AlertItemModel(
                    title: "Unable To Unblock",
                    message: "Something went wrong. Please try again later."
                )
                completion(false)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        self.alertItemForBlockUserItemView = AlertItemModel(
                            title: "Unable To Unblock",
                            message: "Something went wrong. Please try again later."
                        )
                        completion(false)
                        return
                    }
                
                if let model = self.blockedUsersDataArray.first(where: { $0.id == userUID }) {
                    
                    if let index = self.blockedUsersDataArray.firstIndex(of: model) {
                        self.blockedUsersDataArray.remove(at: index)
                    } else {
                        print("Failed To Remove Index Data From Blocked Users Data Array. 😒😒😒")
                        
                    }
                } else {
                    print("Failed To Remove Index Data From Blocked Users Data Array. 😒😒😒")
                }
                
                print("🖤🖤🖤 isCompleted: \(status)")
                print("The User Has Been Unblocked Successfully. ❤️❤️❤️")
                completion(true)
            }
        }
    }
}
