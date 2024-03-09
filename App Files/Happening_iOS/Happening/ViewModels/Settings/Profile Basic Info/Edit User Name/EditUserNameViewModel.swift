//
//  EditUserNameViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class EditUserNameViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = EditUserNameViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // an array to store names except username
    @Published var arrayOfNames = [String]()
    
    // selection variables for picker
    @Published var selectionName1: String = ""
    @Published var selectionName2: String = ""
    
    // present an alert item for EditUserNameView
    @Published var alertItemForEditUserNameView: AlertItemModel?
    
    // present a progress view while updating the user name to firestore
    @Published var isPresentedUpdatingProgress: Bool = false
    
    // firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getUserNameAndFullNameDataFromFirestore
    func getUserNameAndFullNameDataFromFirestore(completionHandler: @escaping (_ status: Bool, _ names:[String], _ userName: String) -> ()) {
        
        guard let docID = currentUser.currentUserUID else {  return }
        
        firestoreListener?.remove()
        firestoreListener = db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    completionHandler(false, [], "")
                    return
                } else {
                    guard let document = snapshot else {
                        completionHandler(false, [], "")
                        return
                    }
                    
                    guard
                        let fn = document.get("FullName") as? [String:String],
                        let userName = document.get("UserName") as? String else {
                            completionHandler(false, [], "")
                            return
                        }
                    
                    let firstName = fn["FirstName"]
                    let middleName = fn["MiddleName"]
                    let lastName = fn["LastName"]
                    let surName = fn["SurName"]
                    
                    let names: [String] = [firstName!, middleName!, lastName!, surName!]
                    
                    print("Names & User Name Has Been Fetched From Firestore Successfully. 🤓🤓🤓")
                    completionHandler(true, names, userName)
                }
            }
    }
    
    // MARK: saveUserNameToFirestore
    func saveUserNameToFirestore() {
        
        guard let docID = currentUser.currentUserUID else {
            alertItemForEditUserNameView = AlertItemModel(title: "Unable to Update User Name", message: "Please, try again in a moment.")
            isPresentedUpdatingProgress = false
            return
        }
        
        let userName = "\(selectionName1) \(selectionName2)"
        
        db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .updateData(["UserName":userName]) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.isPresentedUpdatingProgress = false
                    self.alertItemForEditUserNameView = AlertItemModel(title: "Unable to Update User Name", message: "Please, try again in a moment.")
                } else {
                    print("User Name Has Been Successfully Updated. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                    self.isPresentedUpdatingProgress = false
                    self.alertItemForEditUserNameView = AlertItemModel(title: "User Name Update Successful", message: "")
                }
            }
    }
}
