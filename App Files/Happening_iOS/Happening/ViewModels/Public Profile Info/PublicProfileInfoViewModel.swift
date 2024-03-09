//
//  PublicProfileInfoViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-15.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class PublicProfileInfoViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = PublicProfileInfoViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to MyQRCodeViewModel
    let qrCodeVM = QRCodeViewModel.shared
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // store all the public profile data of a purticular user in this array
    @Published var publicProfileInfoDataObject: PublicProfileInfoModel?
    
    // present a progress view while following or unfollowing
    @Published var followingUnfollowingProgressView: Bool = false
    
    // present an alert item for PublicProfileInfoView
    @Published var alertItemForPublicProfileInfoView: AlertItemModel?
    
    // firestore snapshot listner registers that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener1: ListenerRegistration?
    var firestoreListener2: ListenerRegistration?
    var firestoreListener3: ListenerRegistration?
    var firestoreListener4: ListenerRegistration?
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: checkPrivateCodeGetDocID
    private func checkPrivateCodeGetDocID(privateQRCode: String?, completion: @escaping (_ qrCodeUserDocID: String, _ myUserUID: String) -> ()) {
        
        // check and make sure the private code is not nil
        guard
            let privateQRCode = privateQRCode,
            let myUserUID = currentUser.currentUserUID else {
                qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                    title: "Unable to Find User",
                    message: "Please try again in a moment.",
                    dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                )
                return
            }
        
        // check the given private code is not mine.
        if(privateQRCode == qrCodeVM.privateCode) {
            self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                title: "It's Your QR Code",
                message: "",
                dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
            )
            print("It's Your QR Code")
            return
        }
        
        // get the document id where its private code is equal to given private code
        db
            .collection("Users")
            .whereField("privateQRCode", isEqualTo: privateQRCode)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    
                    guard let querySnapshot = querySnapshot else {
                        self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                            title: "Unable to Find User",
                            message: "Please try again in a moment.",
                            dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                        )
                        return
                    }
                    
                    // if there's no document assigned to given private code
                    // present an alert to user and dismiss sheet if opened
                    if(querySnapshot.documents.isEmpty) {
                        self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                            title: "QR Code No Longer Valid",
                            message: "",
                            dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                        )
                        print("QR Code No Longer Valid")
                        return
                    } else { // if there's a document to provided private code
                        for document in querySnapshot.documents {
                            
                            // check and make sure the given private code is not belongs to me
                            // if the qr code view model private code goes nil, the below condition will prevent from scanning own qr code and leads to corrupt data
                            if(document.documentID == myUserUID) {
                                self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                                    title: "It's Your QR Code",
                                    message: "",
                                    dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                                )
                                print("It's Your QR Code")
                                return
                            } else {
                                // if it's  not my qr code, return the document id of the qr code user
                                let usersDocID = document.documentID
                                
                                completion(usersDocID, myUserUID)
                                print("Document ID Related To QR Code User Has Been Found Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                            }
                        }
                    }
                }
            }
    }
    
    // MARK: checkQRCodeUserGetDocuments
    private func checkQRCodeUserGetDocuments(myUserUID: String, qrCodeUserDocID: String, completion: @escaping (_ followerDataSet: [String:Any]?, _ followingDataSet: [String:Any]?) -> ()) {
        
        var followerDataSet: [String:Any]?
        var followingDataSet: [String:Any]?
        
        // first get the followings data set from my end
        firestoreListener1?.remove()
        firestoreListener1 = db
            .collection("Users/\(myUserUID)/FollowingsData")
            .document(qrCodeUserDocID)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                        title: "Unable to Find User",
                        message: error.localizedDescription,
                        dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                    )
                    return
                } else {
                    guard let documentSnapshot = documentSnapshot else {
                        self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                            title: "Unable to Find User",
                            message: "Please try again in a moment.",
                            dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                        )
                        return
                    }
                    
                    // if there's a document that relates to qr code user in my followings data sub collection, return it
                    if(documentSnapshot.exists) {
                        followingDataSet = documentSnapshot.data()
                    }
                    
                    self.firestoreListener2?.remove()
                    self.firestoreListener2 = self.db
                        .collection("Users/\(myUserUID)/FollowersData")
                        .document(qrCodeUserDocID)
                        .addSnapshotListener {documentSnapshot, error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                                    title: "Unable to Find User",
                                    message: error.localizedDescription,
                                    dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                                )
                                return
                            } else {
                                guard let documentSnapshot = documentSnapshot else {
                                    self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                                        title: "Unable to Find User",
                                        message: "Please try again in a moment.",
                                        dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                                    )
                                    return
                                }
                                
                                // if there's a document that relates to qr code user in my followers data sub collection, return it
                                if(documentSnapshot.exists) {
                                    followerDataSet = documentSnapshot.data()
                                }
                                
                                completion(followerDataSet, followingDataSet)
                                print("Data Sets Have Been Retreived Successfully. 👍🏻👍🏻👍🏻")
                            }
                        }
                }
            }
    }
    
    // MARK: checkBlockFollowerFollowingStatus
    private func checkBlockFollowerFollowingStatus(followerDataSet: [String:Any]?, followingDataSet: [String:Any]?, qrCodeUserDocID: String, completion: @escaping (_ isBlocked: Bool, _ isQrCodeUserFollowingMe: Bool, _ amIFollowingQRCodeUser: Bool) -> ()) {
        
        var isBlocked: Bool = false
        var isQrCodeUserFollowingMe: Bool = false
        var amIFollowingQRCodeUser: Bool = false
        
        var followingBlock: Bool =  false
        var followerBlock: Bool = false
        
        // 1. check block status as a following
        if let followingDataSet = followingDataSet {
            if let followingBlockStatus = followingDataSet["isBlocked"] as? Bool {
                followingBlock = followingBlockStatus
            }
        }
        
        // 2. check block status as a follower
        if let followerDataSet = followerDataSet {
            if let followerBlockStatus = followerDataSet["isBlocked"] as? Bool {
                followerBlock = followerBlockStatus
            }
        }
        
        // 3. if blocked as a following or folower, that means blocked.
        if(followingBlock || followerBlock) {
            isBlocked = true
        }
        
        // 4. if not blocked, proceed
        if(!isBlocked) {
            // 5. check whether the qr code user is following me or not
            if(followerDataSet != nil) {
                isQrCodeUserFollowingMe = true
            }
            
            // 6. check whether the i'm following the qr code user or not
            if(followingDataSet != nil) {
                amIFollowingQRCodeUser =  true
            }
        }
        
        completion(isBlocked, isQrCodeUserFollowingMe, amIFollowingQRCodeUser)
        print("Blocked / Following / Follower  Statuses Has Been Determined Successfully. 🤓🤓🤓")
    }
    
    // MARK: getUsersPublicProfileInfo
    private func getUsersPublicProfileInfo(qrCodeUserDocID: String, isBlocked: Bool, isQrCodeUserFollowingMe: Bool, amIFollowingQRCodeUser: Bool) {
        
        if(isBlocked) {
            self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                title: "Profile Blocked",
                message: "Either you or  the user has been blocked.",
                dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
            )
            return
        }
        
        // if not blocked proceed to fetch data from firestore
        db
            .collection("Users/\(qrCodeUserDocID)/ProfileData")
            .document(qrCodeUserDocID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                        title: "Unable to Find User",
                        message: error.localizedDescription,
                        dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                    )
                    return
                } else {
                    guard let documentSnapshot = documentSnapshot else {
                        self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                            title: "Unable to Find User",
                            message: "Please try again in a moment.",
                            dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                        )
                        return
                    }
                    
                    if(!documentSnapshot.exists) {
                        self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                            title: "Unable to Find User",
                            message: "Please try again in a moment.",
                            dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                        )
                        return
                    }
                    
                    guard let data = documentSnapshot.data() else {
                        self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                            title: "Unable to Find User",
                            message: "Please try again in a moment.",
                            dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                        )
                        return
                    }
                    
                    let object = PublicProfileInfoModel(data: data, qrCodeUserUID: qrCodeUserDocID, isQrCodeUserFollowingMe: isQrCodeUserFollowingMe, amIFollowingQRCodeUser: amIFollowingQRCodeUser)
                    
                    self.publicProfileInfoDataObject = nil
                    self.publicProfileInfoDataObject = object
                    print("QR Code User Data Has Been Fetched Successfully. 🥳🥳🥳")
                }
            }
    }
    
    // MARK: followUserByQRCode
    func followUserByQRCode(privateQRCodeData: String) {
        checkPrivateCodeGetDocID(privateQRCode: privateQRCodeData) { qrCodeUserDocID, myUserUID in
            
            self.checkQRCodeUserGetDocuments(myUserUID: myUserUID, qrCodeUserDocID: qrCodeUserDocID) { followerDataSet, followingDataSet in
                
                self.checkBlockFollowerFollowingStatus(followerDataSet: followerDataSet, followingDataSet: followingDataSet, qrCodeUserDocID: qrCodeUserDocID) { isBlocked, isQrCodeUserFollowingMe, amIFollowingQRCodeUser in
                    
                    self.getUsersPublicProfileInfo(qrCodeUserDocID: qrCodeUserDocID, isBlocked: isBlocked, isQrCodeUserFollowingMe: isQrCodeUserFollowingMe, amIFollowingQRCodeUser: amIFollowingQRCodeUser)
                }
            }
        }
    }
    
    // MARK: followQRCodeUser
    private func followUser(myUserUID: String, qrCodeUserUID: String, completion: @escaping (_ status: Bool) -> ()) {
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "myDocID": myUserUID,
            "userDocID": qrCodeUserUID,
            "collectionName": "Users",
            "followersSubCName": "FollowersData",
            "followingSubCName": "FollowingsData"
        ]
        
        functions.httpsCallable("followUser").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                    title: "Unable To Follow",
                    message: "Something went wrong. Please try again later.",
                    dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                )
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                            title: "Unable To Follow",
                            message: "Something went wrong. Please try again later.",
                            dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                        )
                        return
                    }
                self.followingUnfollowingProgressView =  false
                print("🖤🖤🖤 isCompleted: \(status)")
                print("The User Has Been Followed By You Successfully. ❤️❤️❤️")
                completion(status)
            }
        }
    }
    
    // MARK: unfollowQRCodeUser
    private func unfollowUser(myUserUID: String, qrCodeUserUID: String, completion: @escaping (_ status: Bool) -> ()) {
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "myDocID": myUserUID,
            "userDocID": qrCodeUserUID,
            "collectionName": "Users",
            "followersSubCName": "FollowersData",
            "followingSubCName": "FollowingsData"
        ]
        
        functions.httpsCallable("unfollowUser").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                    title: "Unable To Unfollow",
                    message: "Something went wrong. Please try again later.",
                    dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                )
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                            title: "Unable To Unfollow",
                            message: "Something went wrong. Please try again later.",
                            dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
                        )
                        return
                    }
                
                self.followingUnfollowingProgressView =  false
                print("🖤🖤🖤 isCompleted: \(status)")
                print("The User Has Been Unfollowed By You Successfully. ❤️❤️❤️")
                completion(status)
            }
        }
    }
    
    // MARK: FollowUnfollowDeterminer
    func FollowUnfollowDeterminer(qrCodeUserUID: String, amIFollowingQRCodeUser: Bool, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let myDocID = currentUser.currentUserUID else {
            self.qrCodeVM.isPresentedAlertItemForPublicProfileInfoSheet = AlertItemModel(
                title: "Unable To Follow/Unfollow",
                message: "Something went wrong. Please try again later.",
                dismissButton: .cancel(Text("OK")){ self.qrCodeVM.isPresentedSheetForFollowingUsers = false }
            )
            return
        }
        
        if(!amIFollowingQRCodeUser) {
            // follow
            followUser(myUserUID: myDocID, qrCodeUserUID: qrCodeUserUID) { status in
                completion(status)
            }
        } else {
            // unfollow
            unfollowUser(myUserUID: myDocID, qrCodeUserUID: qrCodeUserUID) { status in
                completion(status)
            }
        }
    }
    
    // MARK: getPublicProfileInfoFromUserUID
    func getPublicProfileInfoFromUserUID(userUID: String, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let myuserUID = currentUser.currentUserUID else {
            alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
            return
        }
        
        checkUserGetDocuments(myUserUID: myuserUID, userDocID: userUID) { followerDataSet, followingDataSet in
            
            self.getBlockFollowerFollowingStatus(followerDataSet: followerDataSet, followingDataSet: followingDataSet, userDocID: userUID) { isBlocked, isUserFollowingMe, amIFollowingUser in
                
                self.getUserPublicProfileInfo(userDocID: userUID, isBlocked: isBlocked, isUserFollowingMe: isUserFollowingMe, amIFollowingUser: amIFollowingUser) { status in
                    completion(status)
                }
            }
        }
    }
    
    // MARK: checkUserGetDocuments
    private func checkUserGetDocuments(myUserUID: String, userDocID: String, completion: @escaping (_ followerDataSet: [String:Any]?, _ followingDataSet: [String:Any]?) -> ()) {
        
        var followerDataSet: [String:Any]?
        var followingDataSet: [String:Any]?
        
        // first get the followings data set from my end
        firestoreListener3?.remove()
        firestoreListener3 = db
            .collection("Users/\(myUserUID)/FollowingsData")
            .document(userDocID)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
                    return
                } else {
                    guard let documentSnapshot = documentSnapshot else {
                        self.alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
                        return
                    }
                    
                    // if there's a document that relates to qr code user in my followings data sub collection, return it
                    if(documentSnapshot.exists) {
                        followingDataSet = documentSnapshot.data()
                    }
                    
                    self.firestoreListener4?.remove()
                    self.firestoreListener4 = self.db
                        .collection("Users/\(myUserUID)/FollowersData")
                        .document(userDocID)
                        .addSnapshotListener {documentSnapshot, error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                self.alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
                                return
                            } else {
                                guard let documentSnapshot = documentSnapshot else {
                                    self.alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
                                    return
                                }
                                
                                // if there's a document that relates to qr code user in my followers data sub collection, return it
                                if(documentSnapshot.exists) {
                                    followerDataSet = documentSnapshot.data()
                                }
                                
                                completion(followerDataSet, followingDataSet)
                                print("Data Sets Have Been Retreived Successfully. 👍🏻👍🏻👍🏻")
                            }
                        }
                }
            }
    }
    
    // MARK: getBlockFollowerFollowingStatus
    private func getBlockFollowerFollowingStatus(followerDataSet: [String:Any]?, followingDataSet: [String:Any]?, userDocID: String, completion: @escaping (_ isBlocked: Bool, _ isUserFollowingMe: Bool, _ amIFollowingUser: Bool) -> ()) {
        
        var isBlocked: Bool = false
        var isUserFollowingMe: Bool = false
        var amIFollowingUser: Bool = false
        
        var followingBlock: Bool =  false
        var followerBlock: Bool = false
        
        // 1. check block status as a following
        if let followingDataSet = followingDataSet {
            if let followingBlockStatus = followingDataSet["isBlocked"] as? Bool {
                followingBlock = followingBlockStatus
            }
        }
        
        // 2. check block status as a follower
        if let followerDataSet = followerDataSet {
            if let followerBlockStatus = followerDataSet["isBlocked"] as? Bool {
                followerBlock = followerBlockStatus
            }
        }
        
        // 3. if blocked as a following or folower, that means blocked.
        if(followingBlock || followerBlock) {
            isBlocked = true
        }
        
        // 4. if not blocked, proceed
        if(!isBlocked) {
            // 5. check whether the qr code user is following me or not
            if(followerDataSet != nil) {
                isUserFollowingMe = true
            }
            
            // 6. check whether the i'm following the qr code user or not
            if(followingDataSet != nil) {
                amIFollowingUser =  true
            }
        }
        
        completion(isBlocked, isUserFollowingMe, amIFollowingUser)
        print("Blocked / Following / Follower  Statuses Has Been Determined Successfully. 🤓🤓🤓")
    }
    
    // MARK: getUserPublicProfileInfo
    private func getUserPublicProfileInfo(userDocID: String, isBlocked: Bool, isUserFollowingMe: Bool, amIFollowingUser: Bool, completion: @escaping (_ status: Bool) -> ()) {
        
        if(isBlocked) {
            completion(false)
            return
        }
        
        // if not blocked proceed to fetch data from firestore
        db
            .collection("Users/\(userDocID)/ProfileData")
            .document(userDocID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
                    completion(false)
                    return
                } else {
                    guard let documentSnapshot = documentSnapshot else {
                        self.alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
                        completion(false)
                        return
                    }
                    
                    if(!documentSnapshot.exists) {
                        self.alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
                        completion(false)
                        return
                    }
                    
                    guard let data = documentSnapshot.data() else {
                        self.alertItemForPublicProfileInfoView = AlertItemModel(title: "Something Went Wrong", message: "Please try again in a moment.")
                        completion(false)
                        return
                    }
                    
                    let object = PublicProfileInfoModel(data: data, qrCodeUserUID: userDocID, isQrCodeUserFollowingMe: isUserFollowingMe, amIFollowingQRCodeUser: amIFollowingUser)
                    
                    self.publicProfileInfoDataObject = object
                    
                    completion(true)
                    print("User Data Has Been Fetched Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                }
            }
    }
}
