//
//  EditEmailAddressViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class EditEmailAddressViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = EditEmailAddressViewModel()
    
    let profileBasicInfoViewModel = ProfileBasicInfoViewModel.shared
    
    // reference to EditProfileViewModel
    let editProfileViewModel = EditProfileViewModel.shared
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // refernce to UserDefaults
    let defaults = UserDefaults.standard
    
    @Published var emailTextFieldText: String = ""
    
    // controls the disability of the verify email address button
    @Published var isDisabledVerifyEmailAddressButton: Bool = true
    
    // controls the sheet related email address verification process
    @Published var isPresentedEmailVerificationSheet: Bool = false
    
    @Published var isVerfiedEmailAddress: VerificationStatus = .verify
    
    @Published var alertItemForEditEmailAddressView: AlertItemModel?
    
    // firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getEmail
    func getEmailAddressFromFirestore() {
        
        guard let docID = currentUser.currentUserUID else {
            alertItemForEditEmailAddressView = AlertItemModel(title: "Unable To Update Email Address", message: "Please try again in a moment.")
            return
        }
        
        firestoreListener?.remove()
        firestoreListener = db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.alertItemForEditEmailAddressView = AlertItemModel(title: "Unable To Update Email Address", message: error.localizedDescription)
                } else {
                    guard let document = snapshot else {
                        self.alertItemForEditEmailAddressView = AlertItemModel(title: "Unable To Update Email Address", message: "Please try again in a moment.")
                        return
                    }
                    
                    let emailAddress = document.get("EmailAddress") as! String
                    
                    self.defaults.set(emailAddress, forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.email.rawValue)
                    
                    self.emailTextFieldText = self.defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.email.rawValue) ?? "..."
                    
                    print("Email Address Has Been Fetched From Firestore Successfully. 👍🏻👍🏻👍🏻")
                }
            }
    }
    
    // MARK: resetEmailAddressView
    func resetEmailAddressView() {
        self.emailTextFieldText = defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.email.rawValue) ?? "..."
    }
    
    // MARK: emailAddressTextFieldValidation
    func emailAddressTextFieldValidation() {
        if(self.emailTextFieldText == defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.email.rawValue) ?? "...") {
            self.isDisabledVerifyEmailAddressButton = true
        } else {
            self.isDisabledVerifyEmailAddressButton = false
        }
    }
}
