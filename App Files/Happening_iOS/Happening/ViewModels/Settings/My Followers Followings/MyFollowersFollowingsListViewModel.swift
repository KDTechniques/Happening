//
//  MyFollowersSectionViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class MyFollowersFollowingsListViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = MyFollowersFollowingsListViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to UserProfileInfoViewModel
    let userProfileInfoVM = UserProfileInfoViewModel.shared
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // present an alert item for FollowerFollowingView
    @Published var alertItemForFollowerFollowingListView: AlertItemModel?
    
    // follower or following picker type selector
    @Published var followerFollowingSelection: followerFollowingSelectionTypes = .followers
    
    // follower or following picker type selection coordinator
    @Published var followerFollowingSelectionCoordinator: followerFollowingSelectionTypes?
    
    // follower or following types for picker
    enum followerFollowingSelectionTypes: String, CaseIterable {
        case followers = "Followers"
        case followings = "Followings"
    }
    
    // controls number of followers and followings
    @Published var numberOfFollowers: Int = 0
    @Published var numberOfFollowings: Int = 0
    
    // search text for Followers or Followings view
    @Published var followersSearchText: String = "" {
        didSet {
            filterFollowerResults(text: followersSearchText)
        }
    }
    @Published var followingsSearchText: String = "" {
        didSet {
            filterFollowingResults(text: followingsSearchText)
        }
    }
    
    // state whether the user is searching on Followers or Followings view or not
    @Published var isSearchingFollowers: Bool = false
    @Published var isSearchingFollowings: Bool = false
    
    // store all the followers data in this array
    @Published var myFollowersDataArray = [MyFollowersModel]() {
        didSet {
            orderedMyFollowerItemsArray = myFollowersDataArray
            
            let count = myFollowersDataArray.count
            numberOfFollowers = count
        }
    }
    
    // store all of the ordered my followers in this array that confirms to MyFollowersModel
    @Published var orderedMyFollowerItemsArray = [MyFollowersModel]()
    
    // store all the followings data in this array
    @Published var myFollowingsDataArray = [MyFollowingsModel]() {
        didSet {
            orderedMyFollowingItemsArray = myFollowingsDataArray
            
            let count = myFollowingsDataArray.count
            numberOfFollowings = count
            
            updateOrderedArray(type: .followedLatest)
        }
    }
    
    // store all of the ordered my followings in this array that confirms to MyFollowingsModel
    @Published var orderedMyFollowingItemsArray = [MyFollowingsModel]()
    
    // controls the sorting type of the followings list view
    enum followingsSortingTypes {
        case followedLatest
        case followedEarliest
    }
    
    // controls the current sorting type of the following list view
    @Published var followingsSortingSelection: followingsSortingTypes = .followedLatest {
        didSet {
            updateOrderedArray(type: followingsSortingSelection)
        }
    }
    
    // present a progress view while following, unfollowing or removing a user
    @Published var isPresentedProgressView: Bool = false
    
    // action sheet item for FollowerFollowingListView
    @Published var actionSheetItemForFollowerFollowingListView: RemoveBlockUnblockFollowerActionSheetModel?
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getFollowersDataFromFirestore
    func getFollowersDataFromFirestore() {
        
        // make sure my user uid is not nil
        guard let docID = currentUser.currentUserUID else {
            alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
            return
        }
        
        // get all the available documents from my followers data sub collection
        db
            .collection("Users/\(docID)/FollowersData")
            .whereField("isBlocked", isEqualTo: false)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: error.localizedDescription)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot else {
                        self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                        return
                    }
                    
                    self.numberOfFollowers = 0
                    self.myFollowersDataArray.removeAll() // for safety reasons
                    
                    var dataSet1: [String: Any]?
                    var dataSet2: [String: Any]?
                    
                    var userID: String?
                    
                    for document in querySnapshot.documents {
                        if(!document.exists) { return }
                        
                        self.numberOfFollowers += 1
                        
                        userID = document.documentID
                        dataSet1 = document.data()
                        
                        guard let userID = userID else {
                            return
                        }
                        
                        self.db
                            .collection("Users/\(userID)/ProfileData")
                            .getDocuments { querySnapshot, error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                    self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                                    return
                                } else {
                                    
                                    guard let querySnapshot = querySnapshot else {
                                        self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                                        return
                                    }
                                    
                                    for document in querySnapshot.documents {
                                        dataSet2 = document.data()
                                    }
                                    
                                    guard
                                        let dataSet1 = dataSet1,
                                        let dataSet2 = dataSet2 else {
                                            self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                                            return
                                        }
                                    
                                    var mergedDataSet = dataSet1
                                    
                                    mergedDataSet.merge(dataSet2) {(current, _) in current}
                                    
                                    var amIFollowingUser: Bool = false
                                    
                                    self.db
                                        .collection("Users/\(docID)/FollowingsData")
                                        .document(userID)
                                        .getDocument { documentSnapshot, error in
                                            if let error = error {
                                                print("Error: \(error.localizedDescription)")
                                                self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                                                return
                                            } else {
                                                guard let documentSnapshot = documentSnapshot else {
                                                    self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                                                    return
                                                }
                                                
                                                amIFollowingUser = documentSnapshot.exists
                                                
                                                let object = MyFollowersModel(dataSet: mergedDataSet, docID: userID, amIFollowingUser: amIFollowingUser)
                                                
                                                self.myFollowersDataArray.append(object)
                                            }
                                        }
                                }
                            }
                    }
                    print("Followers Data Documents Have Been Retrieved Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                }
            }
    }
    
    // MARK: getFollowingsDataFromFirestore
    func getFollowingsDataFromFirestore() {
        
        // make sure my user uid is not nil
        guard let docID = currentUser.currentUserUID else {
            alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
            return
        }
        
        // get all the available  documents from my followings sub collection
        db
            .collection("Users/\(docID)/FollowingsData")
            .whereField("isBlocked", isEqualTo: false)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: error.localizedDescription)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot else {
                        self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                        return
                    }
                    
                    self.numberOfFollowings = 0
                    self.myFollowingsDataArray.removeAll() // for safety reasons
                    
                    var dataSet1: [String: Any]?
                    var dataSet2: [String: Any]?
                    
                    var userID: String?
                    
                    for document in querySnapshot.documents {
                        if(!document.exists) { return }
                        
                        self.numberOfFollowings += 1
                        
                        userID = document.documentID
                        dataSet1 = document.data()
                        
                        guard let userID = userID else {
                            return
                        }
                        
                        self.db
                            .collection("Users/\(userID)/ProfileData")
                            .getDocuments { querySnapshot, error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                    self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                                    return
                                } else {
                                    
                                    guard let querySnapshot = querySnapshot else {
                                        self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                                        return
                                    }
                                    
                                    for document in querySnapshot.documents {
                                        dataSet2 = document.data()
                                    }
                                    
                                    guard
                                        let dataSet1 = dataSet1,
                                        let dataSet2 = dataSet2 else {
                                            self.alertItemForFollowerFollowingListView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                                            return
                                        }
                                    
                                    var mergedDataSet = dataSet1
                                    
                                    mergedDataSet.merge(dataSet2) {(current, _) in current}
                                    
                                    let object = MyFollowingsModel(dataSet: mergedDataSet, docID: userID)
                                    
                                    self.myFollowingsDataArray.append(object)
                                }
                            }
                    }
                    print("Followings Data Documents Have Been Retrieved Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                }
            }
    }
    
    // MARK: blockUser
    func blockUser(userUID: String, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            userProfileInfoVM.alertItemForUserProfileInfoView = AlertItemModel(
                title: "Unable To Block",
                message: "Something went wrong. Please try again later."
            )
            completion(false)
            return
        }
        
        if let model = self.myFollowingsDataArray.first(where: { $0.id == userUID }) {
            
            if let index = self.myFollowingsDataArray.firstIndex(of: model) {
                self.myFollowingsDataArray.remove(at: index)
            } else {
                print("Failed To Remove Index Data From Followers Data Array. 😒😒😒")
                self.getFollowingsDataFromFirestore()
            }
        } else {
            print("Failed To Remove Index Data From Followers Data Array. 😒😒😒")
            self.getFollowingsDataFromFirestore()
        }
        
        if let model = self.myFollowersDataArray.first(where: { $0.id == userUID }) {
            
            if let index = self.myFollowersDataArray.firstIndex(of: model) {
                self.myFollowersDataArray.remove(at: index)
            } else {
                print("Failed To Remove Index Data From Followers Data Array. 😒😒😒")
                self.getFollowersDataFromFirestore()
            }
        } else {
            print("Failed To Remove Index Data From Followers Data Array. 😒😒😒")
            self.getFollowersDataFromFirestore()
        }
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "myDocID": myUserUID,
            "userDocID": userUID,
            "collectionName": "Users",
            "followersSubCName": "FollowersData",
            "followingSubCName": "FollowingsData"
        ]
        
        functions.httpsCallable("blockUser").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                self.userProfileInfoVM.alertItemForUserProfileInfoView = AlertItemModel(
                    title: "Unable To Block",
                    message: "Something went wrong. Please try again later."
                )
                completion(false)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        self.userProfileInfoVM.alertItemForUserProfileInfoView = AlertItemModel(
                            title: "Unable To Block",
                            message: "Something went wrong. Please try again later."
                        )
                        completion(false)
                        return
                    }
    
                print("🖤🖤🖤 isCompleted: \(status)")
                print("The Follower Has Been Blocked Successfully. ❤️❤️❤️")
                completion(true)
            }
        }
    }
    
    // MARK: removeUser
    func removeFollower(userUID: String, completion: @escaping (_ status: Bool)  -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            self.alertItemForFollowerFollowingListView = AlertItemModel(
                title: "Unable To Remove",
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
        
        functions.httpsCallable("removeFollower").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                self.alertItemForFollowerFollowingListView = AlertItemModel(
                    title: "Unable To Remove",
                    message: "Something went wrong. Please try again later."
                )
                completion(false)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        self.alertItemForFollowerFollowingListView = AlertItemModel(
                            title: "Unable To Remove",
                            message: "Something went wrong. Please try again later."
                        )
                        completion(false)
                        return
                    }
                self.isPresentedProgressView =  false
                print("🖤🖤🖤 isCompleted: \(status)")
                print("The Follower Has Been Removed Successfully. ❤️❤️❤️")
                completion(true)
            }
        }
    }
    
    // MARK: followUser
    func followUser(myUserUID: String, userUID: String, completion: @escaping (_ status: Bool) -> ()) {
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "myDocID": myUserUID,
            "userDocID": userUID,
            "collectionName": "Users",
            "followersSubCName": "FollowersData",
            "followingSubCName": "FollowingsData"
        ]
        
        functions.httpsCallable("followUser").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                self.alertItemForFollowerFollowingListView = AlertItemModel(
                    title: "Unable To Follow",
                    message: "Something went wrong. Please try again later."
                )
                completion(false)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        self.alertItemForFollowerFollowingListView = AlertItemModel(
                            title: "Unable To Follow",
                            message: "Something went wrong. Please try again later."
                        )
                        completion(false)
                        return
                    }
                self.isPresentedProgressView =  false
                print("🖤🖤🖤 isCompleted: \(status)")
                print("The User Has Been Followed By You Successfully. ❤️❤️❤️")
                completion(true)
            }
        }
    }
    
    // MARK: unfollowUser
    func unfollowUser(myUserUID: String, userUID: String, completion: @escaping (_ status: Bool) -> ()) {
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "myDocID": myUserUID,
            "userDocID": userUID,
            "collectionName": "Users",
            "followersSubCName": "FollowersData",
            "followingSubCName": "FollowingsData"
        ]
        
        functions.httpsCallable("unfollowUser").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                self.alertItemForFollowerFollowingListView = AlertItemModel(
                    title: "Unable To Unfollow",
                    message: "Something went wrong. Please try again later."
                )
                completion(false)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        self.alertItemForFollowerFollowingListView = AlertItemModel(
                            title: "Unable To Unfollow",
                            message: "Something went wrong. Please try again later."
                        )
                        completion(false)
                        return
                    }
                
                self.isPresentedProgressView =  false
                print("🖤🖤🖤 isCompleted: \(status)")
                print("The User Has Been Unfollowed By You Successfully. ❤️❤️❤️")
                completion(true)
            }
        }
    }
    
    // MARK: FollowUnfollowDeterminer
    func FollowUnfollowDeterminer(userUID: String, amIFollowingQRCodeUser: Bool, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let myDocID = currentUser.currentUserUID else {
            self.alertItemForFollowerFollowingListView = AlertItemModel(
                title: "Unable To Follow/Unfollow",
                message: "Something went wrong. Please try again later."
            )
            return
        }
        
        if(!amIFollowingQRCodeUser) {
            // follow
            followUser(myUserUID: myDocID, userUID: userUID) { status in
                completion(status)
            }
        } else {
            // unfollow
            unfollowUser(myUserUID: myDocID, userUID: userUID) { status in
                completion(status)
            }
        }
    }
    
    // MARK: filterFollowerResults
    func filterFollowerResults(text: String) {
        if(text.isEmpty) {
            orderedMyFollowerItemsArray = myFollowersDataArray
        } else {
            orderedMyFollowerItemsArray  =  myFollowersDataArray.filter { $0.userName.localizedCaseInsensitiveContains(text) }
        }
    }
    
    // MARK: filterFollowingResults
    func filterFollowingResults(text: String) {
        if(text.isEmpty) {
            orderedMyFollowingItemsArray = myFollowingsDataArray
        } else {
            orderedMyFollowingItemsArray  =  myFollowingsDataArray.filter { $0.userName.localizedCaseInsensitiveContains(text) }
        }
    }
    
    // MARK: updateOrderedArray
    func updateOrderedArray(type: followingsSortingTypes) {
        if(type == .followedLatest) {
            orderedMyFollowingItemsArray = myFollowingsDataArray.sorted { $0.followedDT < $1.followedDT } // should be - to +
        } else {
            orderedMyFollowingItemsArray = myFollowingsDataArray.sorted { $0.followedDT > $1.followedDT } // should be + to -
        }
    }
}
