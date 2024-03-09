//
//  UserDataViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-16.
//

import Foundation
import Firebase
import SwiftUI

class UserDataViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = UserDataViewModel()
    
    let pendingApprovalViewModel = PendingApprovalViewModel.shared
    
    // let know when all the document ids have been stored to the array
    @Published var getDocumentIDsStatus: Bool = false
    
    // controls the visibility of the list
    @Published var showList: Bool = false
    
    // document data dictionary
    @Published var data: [String:Any]?
    
    // document data available as PendingApprovalModel structure
    @Published var dataObject: PendingApprovalModel?
    
    @Published var isDisabledApproveButton: Bool = false
    
    @Published var isPresentedApproveLoadingView: Bool = false
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: showList
    func showUserDataView() {
        pendingApprovalViewModel.getDocumentIDs { status in
            self.getDocumentIDsStatus = status
            if(status) {
                self.showList = true
            }
        }
    }
    
    // MARK: approveUser
    func approveUser(dataObject: PendingApprovalModel?, data: [String:Any]?, completionHandler: @escaping (_ status: Bool) -> ()) {
        
        guard let object = dataObject else {
            pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: "Please try again in a moment.")
            completionHandler(false)
            return
        }
        
        let db = Firestore.firestore()
        
        guard let data = data else { return }
        
        let docID = object.id
        
        let profileData: [String:Any] = [
            "UserName" : "\(object.firstName) \(object.surName)",
            "Profession" : object.profession,
            "About" : object.about,
            "Address" : ["Street1" : object.street1,
                         "Street2" : object.street2,
                         "City" : object.city,
                         "Postcode" : object.postcode
                        ],
            "PhoneNo" : object.phoneNo,
            "EmailAddress" : object.emailAddress,
            "NICNo" : object.nicNo,
            "BirthDate" : object.birthDate,
            "FullName" : ["FirstName": object.firstName,
                          "MiddleName" : object.middleName,
                          "LastName" : object.lastName,
                          "SurName" : object.surName
                         ],
            "Gender" : object.gender,
            "Ratings" : 5.0
        ]
        
        db
            .collection("Users/\(docID)/ApprovedData")
            .document(docID)
            .setData(data) { error in
                if let error = error {
                    self.pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: error.localizedDescription)
                    print(error.localizedDescription)
                    completionHandler(false)
                    return
                } else {
                    print("Data Has Been Written to Approved Data Subcollection Successfully. 👍🏻👍🏻👍🏻")
                    
                    // delete all the fields from PendingApprovalsData within a purticular document
                    db
                        .collection("Users/\(docID)/PendingApprovalData")
                        .document(docID)
                        .delete { error in
                            if let error = error {
                                self.pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: error.localizedDescription)
                                print(error.localizedDescription)
                                completionHandler(false)
                                return
                            } else {
                                print("Pending Approval Data Document Has Been Deleted Successfully. 👍🏻👍🏻👍🏻")
                            }
                        }
                    
                    // move profile photo from Pending Approvals to Approved Data and store in firestore
                    self.copyMoveFileWithinSameStorageBucket(
                        srcPath: "Pending Approvals/Profile Pictures/\(docID)/\(docID)",
                        destPath: "Approved Data/Profile Pictures/\(docID)/\(docID)",
                        canDelete: true,
                        collectionName: "Users/\(docID)/ApprovedData",
                        documentID: docID,
                        fieldName: "ProfilePhoto") { status in
                            if(status) {
                                db
                                    .collection("Users/\(docID)/ProfileData")
                                    .document(docID)
                                    .setData(profileData) { error in
                                        if let error  = error {
                                            self.pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: error.localizedDescription)
                                            print(error.localizedDescription)
                                            return
                                        } else {
                                            print("Data Has Been Written to Profile Data Subcollection Successfully. 👍🏻👍🏻👍🏻")
                                            
                                            let uuid: String = UUID().uuidString
                                            self.copyMoveFileWithinSameStorageBucket(
                                                srcPath: "Approved Data/Profile Pictures/\(docID)/\(docID)",
                                                destPath: "Profile Data/Profile Pictures/\(docID)/\(uuid)",
                                                canDelete: false, // always false
                                                collectionName: "Users/\(docID)/ProfileData",
                                                documentID: docID,
                                                fieldName: "ProfilePhoto") { status in
                                                    if(status) {
                                                        self.generateThumbnail(
                                                            path: "Profile Data/Profile Pictures/\(docID)/\(uuid)",
                                                            collectionName: "Users/\(docID)/ProfileData",
                                                            documentID: docID,
                                                            fieldName: "ProfilePhotoThumbnail") { status in
                                                                if(status) {
                                                                    let subCollectionLessData: [String:Any] = [
                                                                        "isApproved" : true,
                                                                        "privateQRCode" : "https://happening.me/qr/\(UUID())"
                                                                    ]
                                                                    
                                                                    db
                                                                        .collection("Users")
                                                                        .document(docID)
                                                                        .updateData(subCollectionLessData) { error in
                                                                            if let error = error {
                                                                                self.pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: error.localizedDescription)
                                                                                print(error.localizedDescription)
                                                                                return
                                                                            } else {
                                                                                print("User Has Been Approved Successfully. ❤️❤️❤️")
                                                                                completionHandler(true)
                                                                            }
                                                                        }
                                                                }
                                                            }
                                                    }
                                                }
                                        }
                                    }
                            }
                        }
                    
                    // move nic photo front side from Pending Approvals to Approved Data and store in firestore
                    self.copyMoveFileWithinSameStorageBucket(
                        srcPath: "Pending Approvals/NIC Photos/\(docID)/\(docID)FRONT",
                        destPath: "Approved Data/NIC Photos/\(docID)/\(docID)FRONT",
                        canDelete: true,
                        collectionName: "Users/\(docID)/ApprovedData",
                        documentID: docID,
                        fieldName: "NICPhoto.FrontSide") { _ in }
                    
                    // move nic photo back side from Pending Approvals to Approved Data and store in firestore
                    self.copyMoveFileWithinSameStorageBucket(
                        srcPath: "Pending Approvals/NIC Photos/\(docID)/\(docID)BACK",
                        destPath: "Approved Data/NIC Photos/\(docID)/\(docID)BACK",
                        canDelete: true,
                        collectionName: "Users/\(docID)/ApprovedData",
                        documentID: docID,
                        fieldName: "NICPhoto.BackSide") { _ in }
                }
            }
    }
    
    // MARK: copyMoveFileWithinSameStorageBucket
    func copyMoveFileWithinSameStorageBucket(srcPath: String, destPath: String, canDelete: Bool, collectionName: String, documentID: String, fieldName: String, completionHandler: @escaping (_ status: Bool) -> ()) {
        
        lazy var functions = Functions.functions()
        
        let data: [String:Any] = [
            "srcPath" : srcPath,
            "destPath" : destPath,
            "canDelete" : canDelete,
            "collectionName": collectionName,
            "documentID" : documentID,
            "fieldName" : fieldName
        ]
        
        functions.httpsCallable("copyMoveFileWithinSameStorageBucket").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                completionHandler(false)
                self.pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: error.localizedDescription)
                return
            } else {
                
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        completionHandler(false)
                        self.pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: "Please try again in a moment.")
                        return
                    }
                
                print("❤️❤️❤️ isCompleted: \(status)")
                print("File/s/Folder/s Has Been Copied/Moved From \(srcPath) To \(destPath) and Stored in \(collectionName)/\(documentID) at Field \(fieldName) Successfully.👍🏻👍🏻👍🏻")
                
                completionHandler(status)
            }
        }
    }
    
    // MARK: generateThumbnail
    func generateThumbnail(path: String, collectionName: String, documentID: String, fieldName: String, completionHandler: @escaping (_ status: Bool) -> ()) {
        
        lazy var functions = Functions.functions()
        
        let data: [String:Any] = [
            "imageFilePath" : path,
            "collectionName" : collectionName,
            "documentID" : documentID,
            "fieldName" : fieldName
        ]
        
        functions.httpsCallable("generateThumbnail").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                completionHandler(false)
                self.pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: error.localizedDescription)
                return
            } else {
                
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        completionHandler(false)
                        self.pendingApprovalViewModel.alertForPendingApprovalView = AlertItemModel(title: "Unable to Approve", message: "Please try again in a moment.")
                        return
                    }
                
                print("🖤🖤🖤 isCompleted: \(status)")
                print("Profile Photo Thumbnail Has Been Generated For \(path) and Stored in \(collectionName)/\(documentID) at Field \(fieldName) Successfully.👍🏻👍🏻👍🏻")
                
                completionHandler(status)
            }
        }
    }
}
