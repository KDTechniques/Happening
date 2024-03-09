//
//  EditPhoneNumberViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase
import CoreMedia

class EditPhoneNumberViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = EditPhoneNumberViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to PhoneNoAuthManager class
    let phoneNoAuthManager = PhoneNoAuthManager.shared
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // reference to UserDefaukts
    let defaults = UserDefaults.standard
    
    // phone number text field text
    @Published var phoneNumberTextFieldText: String = ""
    
    // controls the disability of phone number text field
    @Published var isDisabledPhoneNoTextField: Bool = false
    
    // controls the disability of verify button
    @Published var isDisabledVerifyPhoneNumberButton: Bool = true
    
    // controls the sheet related to one time passcode
    @Published var isPresentedPhoneNoVerificationSheet: Bool = false
    
    // present a loading progress view after clicking on the verify phone number button
    @Published var isPresentedLoadingProgress: Bool = false
    
    // decide whether the phone number is verfied or not
    @Published var isVerfiedPhoneNo: VerificationStatus = .verify {
        didSet {
            if(isVerfiedPhoneNo == .verified) {
                updatePhoneNumberToFirestore()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    self.alertItemForEditPhoneNumberView = AlertItemModel(title: "Unable to Update Phone Number", message: "Please try again in a moment.")
                }
            }
        }
    }
    
    // present a alert item for the EditPhoneNumberView
    @Published var alertItemForEditPhoneNumberView: AlertItemModel?
    
    // firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    //MARK: FUNCTIONS
    
    
    
    // MARK: getPhoneNumberFromFirestore
    func getPhoneNumberFromFirestore() {
        
        guard let docID = currentUser.currentUserUID else {
            alertItemForEditPhoneNumberView = AlertItemModel(title: "Unable to Update Phone Number", message: "Please try again in a moment.")
            return
        }
        
        firestoreListener?.remove()
        firestoreListener = db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .addSnapshotListener { snapshot, error in
                if let error =  error {
                    print(error.localizedDescription)
                    self.alertItemForEditPhoneNumberView = AlertItemModel(title: "Unable to Update Phone Number", message: error.localizedDescription)
                } else {
                    guard let document = snapshot else {
                        self.alertItemForEditPhoneNumberView = AlertItemModel(title: "Unable to Update Phone Number", message: "Please try again in a moment.")
                        return
                    }
                    
                    let phoneNumber: String = document.get("PhoneNo") as! String
                    
                    self.defaults.set(phoneNumber, forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.phoneNo.rawValue)
                    
                    self.phoneNumberTextFieldText = self.defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.phoneNo.rawValue) ?? "..."
                    
                    print("Phone Number Has Been Fetched From Firestore Successfully. 👍🏻👍🏻👍🏻")
                }
            }
    }
    
    // MARK: validatePhoneNo
    func validatePhoneNo() {
        if(phoneNumberTextFieldText.count > 10) {
            phoneNumberTextFieldText.removeLast()
            alertItemForEditPhoneNumberView = AlertItemModel(title: "Only 10 Digits Are Allowed", message: "")
        }
        if(phoneNumberTextFieldText.count == 10) {
            isDisabledVerifyPhoneNumberButton = false
        } else {
            isDisabledVerifyPhoneNumberButton = true
        }
        if(phoneNumberTextFieldText == defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.phoneNo.rawValue) ?? "...") {
            isDisabledVerifyPhoneNumberButton = true
        }
    }
    
    // MARK: onClickVerifyButton
    func onClickVerifyButton() {
        isDisabledVerifyPhoneNumberButton = true
        
        phoneNoAuthManager.phoneNumber = phoneNumberTextFieldText
        
        phoneNoAuthManager.sendVerificationCode { status, error in
            if let error = error {
                print(error.localizedDescription)
                self.isPresentedLoadingProgress = false
                self.alertItemForEditPhoneNumberView = AlertItemModel(title: "Unable to Update Phone Number", message: error.localizedDescription)
            } else {
                if(status == .success) {
                    self.isPresentedPhoneNoVerificationSheet = true
                }
            }
        }
    }
    
    // MARK: updatePhoneNumberToFirestore
    func updatePhoneNumberToFirestore() {
        guard let docID = currentUser.currentUserUID else {
            alertItemForEditPhoneNumberView = AlertItemModel(title: "Unable to Update Phone Number", message: "Please try again in a moment.")
            return
        }
        
        let phoneNo = phoneNoAuthManager.phoneNumber
        
        db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .updateData(["PhoneNo":phoneNo]) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.isPresentedLoadingProgress = false
                    self.alertItemForEditPhoneNumberView = AlertItemModel(title: "Unable to Update Phone Number", message: error.localizedDescription)
                } else {
                    print("Phone Number Has Been Updated In Firestore Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                    
                    self.phoneNoAuthManager.phoneNumber = "" // for safety reasons
                    
                    self.defaults.set(self.phoneNumberTextFieldText, forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.phoneNo.rawValue)
                    
                    self.isPresentedLoadingProgress = false
                    self.alertItemForEditPhoneNumberView = AlertItemModel(title: "Phone Number Update Successful", message: "")
                }
            }
    }
}
