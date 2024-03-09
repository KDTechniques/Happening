//
//  ApprovalFormViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-22.
//

import Foundation
import SwiftUI
import Firebase

class ApprovalFormViewModel: ObservableObject {
    
    // MARK: PROPERTIS
    static let shared = ApprovalFormViewModel()
    
    // reference to AuthenticatedUserViewModel class environment object.
    let authenticatedUserViewModel = AuthenticatedUserViewModel.shared
    
    // reference to CurrentUser class environment object.
    let currentUser = CurrentUser.shared
    
    @Published var formData: ApprovalFormModel
    
    // character validation properties
    let validNICCharacterSet = CharacterSet(charactersIn: "0123456789vV")
    
    // character set types
    enum CharacterSetType {
        case alphabetical
        case nic
        case address
    }
    
    // text fields types which can be focusable
    enum FieldType: Hashable {
        // name
        case firstName
        case middleName
        case lastName
        case SurName
        
        case nic
        case age
        
        // address
        case street1
        case street2
        case city
        case postcode
        
        case email
        case phoneNo
    }
    
    // alert items for different sub views
    @Published var alertItemForNameListSection: AlertItemModel? = nil
    @Published var alertItemForNICSection: AlertItemModel? = nil
    @Published var alertItemForAddressListSection: AlertItemModel? = nil
    @Published var alertItemForEmailAddressSection: AlertItemModel? = nil
    @Published var alertItemForPhoneNoSection: AlertItemModel? = nil
    
    // controls the phone number authentication alert
    @Published var isPresentedVerificationCodeSendUnsccessfulAlert: Bool = false
    // controls the sheet related to one time passcode
    @Published var isPresentedPhoneNoVerificationSheet: Bool = false
    // state whether the given phone number is verified or not
    @Published var isVerified: VerificationStatus = .verify {
        didSet {
            enabelSubmitButton()
            if(isVerified == .verified) {
                isDisabledVerifyButton = true
            } else {
                isDisabledVerifyButton = false
            }
        }
    }
    
    // controls the verify button
    @Published var isDisabledVerifyButton: Bool = true
    
    // shows a progress view while open up a sheet by firebase sdk and sending the verfication code
    @Published var isPresentedLoadingView: Bool = false
    
    // shows a progress view while submitting the approval form to the firebase firestore
    @Published var isPresentedSubmitLoadingView: Bool = false
    
    // controls disability of the the approval form
    @Published var isDisabledApprovalForm: Bool = false
    
    // conrols the current focus field
    @Published var fieldInFocus: FieldType?
    
    // relates to date of birth component
    // get the current year as an integer value ex: 2021
    @Published var currentYear: Int = Calendar.current.component(.year, from: Date())
    
    // limit the date of birth to be within a range of 60 years to 16 years
    let startingDate: Date = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()) - 60)) ?? Date()
    let endingDate: Date = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()) - 16)) ?? Date()
    
    // controls the way how date of birth should be displayed on the form
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // 25 December 2021
        return formatter
    }
    
    // controls date picker visibility
    @Published var isPresentedDatePicker: Bool = false
    // shows an alert if an invalid character is being entered
    @Published var isPresentedAlphabeticalCharactersOnlyAlert: Bool = false
    @Published var isPresentedNICCharactersOnlyAlert: Bool = false
    @Published var isPresentedAddressCharactersOnlyAlert: Bool = false
    // shows an alert if email is invalid
    @Published var isPresentedInvalidEmailAlert: Bool = false
    // shows an alert when something went wrong while submitting the approval form to the firebase firestore
    @Published var isPresentedSubmittingErrorAlert: Bool = false
    // make sure all the related photos uploaded successfully
    @Published var photoUploadCount = 0 {
        didSet {
            if(photoUploadCount >= 3) {
                addAllDataSecond(profileURL: profilePhotoURLString, nicFrontURL: nicPhotoFrontSideURLString, nicBackURL: nicPhotoBackSideURLString)
            }
        }
    }
    
    // controls the foreground color of the Name, Date of Birth and Address labels
    @Published var isChangedAccentColorNameField: Bool = false
    @Published var isChangedAccentColorBirthDate: Bool = false
    @Published var isChangedAccentColorAddressField: Bool = false
    // controls the nic photo upload section
    @Published var isPresentedNICImageAlert: Bool = false
    @Published var isPresentedProfilePictureAlert: Bool = false
    @Published var isPresentedPhotoLibrary: Bool = false
    @Published var isAddedFrontImage: Bool = false
    @Published var isAddedBackImage: Bool = false
    @Published var isAddedProfileImage: Bool = false
    @Published var isPresenetedCameraSheet = true
    @Published var showImagePicker1: Bool = false
    @Published var showImagePicker2: Bool = false
    @Published var showImagePicker3: Bool = false
    // decides the status of the form
    // status of whether all the fields are filled or not
    @Published var isCompleted: Bool = false
    
    var profilePhotoURLString = ""
    var nicPhotoFrontSideURLString = ""
    var nicPhotoBackSideURLString = ""
    
    // MARK: INITIALIZER
    init() {
        let initValue = ApprovalFormModel(firstName: "", middleName: "", lastName: "", surName: "", fullName: "Enter Full Name", profession: .none, nic: "", dateOfBirth: Date(), gender: .male, age: "", street1: "", street2: "", city: "", postCode: "", address: "Add Permanent Address", email: "", spCode: "077", phoneNo: "", fullPhoneNo: "", nicFrontImage: UIImage(named: "NICSamplePhotoFrontSide"), nicBackImage: UIImage(named: "NICSamplePhotoBackSide"), profileImage: nil)
        
        self.formData = initValue
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: resetApprovalForm
    func resetApprovalForm() {
        // reset all the fields in the form
        let resetValue = ApprovalFormModel(firstName: "", middleName: "", lastName: "", surName: "", fullName: "Enter Full Name", profession: .none, nic: "", dateOfBirth: Date(), gender: .male, age: "", street1: "", street2: "", city: "", postCode: "", address: "Add Permanent Address", email: "", spCode: "077", phoneNo: "", fullPhoneNo: "", nicFrontImage: UIImage(named: "NICSamplePhotoFrontSide"), nicBackImage: UIImage(named: "NICSamplePhotoBackSide"), profileImage: nil)
        
        self.formData = resetValue
    }
    
    // MARK: SubmitForm
    func submitForm() {
        if(isValidEmail(email: self.formData.email)) {
            isDisabledApprovalForm = true
            isPresentedSubmitLoadingView = true
            // store data to firebase storage and then to firestore
            addPhotosFirst()
        } else {
            alertItemForEmailAddressSection = AlertItemModel(title: "Invalid Email", message: "Enter a valid email address.")
        }
    }
    
    // MARK: addData
    func addPhotosFirst() {
        guard let currentUserUID = currentUser.currentUserUID else {
            isPresentedSubmittingErrorAlert = true
            return
        }
        
        guard
            let profilePhoto = formData.profileImage,
            let nicPhotoFrontSide = formData.nicFrontImage,
            let nicPhotoBackSide = formData.nicBackImage
        else {
            isPresentedSubmittingErrorAlert = true
            return
        }
        
        guard
            let profilePhotoData = profilePhoto.jpegData(compressionQuality: 0.1),
            let nicPhotoFrontSideData = nicPhotoFrontSide.jpegData(compressionQuality: 0.1),
            let nicPhotoBackSideData = nicPhotoBackSide.jpegData(compressionQuality: 0.1)
        else {
            isPresentedSubmittingErrorAlert = true
            return
        }
        
        let profilePhotoReference = Storage.storage().reference()
            .child("Pending Approvals/Profile Pictures/\(currentUserUID)")
            .child(currentUserUID)
        
        let nicPhotoFrontSideReference = Storage.storage().reference()
            .child("Pending Approvals/NIC Photos/\(currentUserUID)")
            .child("\(currentUserUID)FRONT")
        
        let nicPhotoBackSideReference = Storage.storage().reference()
            .child("Pending Approvals/NIC Photos/\(currentUserUID)")
            .child("\(currentUserUID)BACK")
        
        profilePhotoReference.putData(profilePhotoData, metadata: nil) { [weak self] _, error in
            if error != nil {
                self?.isPresentedSubmittingErrorAlert = true
            } else {
                profilePhotoReference.downloadURL { url, error in
                    if error != nil {
                        self?.isPresentedSubmittingErrorAlert = true
                        return
                    } else {
                        guard let url = url else {
                            self?.isPresentedSubmittingErrorAlert = true
                            return
                        }
                        self?.profilePhotoURLString = url.absoluteString
                        self?.photoUploadCount += 1
                    }
                }
            }
        }
        
        nicPhotoFrontSideReference.putData(nicPhotoFrontSideData, metadata: nil) { [weak self] _, error in
            if error != nil {
                self?.isPresentedSubmittingErrorAlert = true
            } else {
                nicPhotoFrontSideReference.downloadURL { url, error in
                    if error != nil {
                        self?.isPresentedSubmittingErrorAlert = true
                        return
                    } else {
                        guard let url = url else {
                            self?.isPresentedSubmittingErrorAlert = true
                            return
                        }
                        self?.nicPhotoFrontSideURLString = url.absoluteString
                        self?.photoUploadCount += 1
                    }
                }
            }
        }
        
        nicPhotoBackSideReference.putData(nicPhotoBackSideData, metadata: nil) { [weak self] _, error in
            if error != nil {
                self?.isPresentedSubmittingErrorAlert = true
            } else {
                nicPhotoBackSideReference.downloadURL { url, error in
                    if error != nil {
                        self?.isPresentedSubmittingErrorAlert = true
                        return
                    } else {
                        guard let url = url else {
                            self?.isPresentedSubmittingErrorAlert = true
                            return
                        }
                        self?.nicPhotoBackSideURLString = url.absoluteString
                        self?.photoUploadCount += 1
                    }
                }
            }
        }
    }
    
    func addAllDataSecond(profileURL: String, nicFrontURL: String, nicBackURL: String) {
        guard let currentUserUID = currentUser.currentUserUID else {
            isPresentedSubmittingErrorAlert = true
            return
        }
        
        let db = Firestore.firestore()
        
        let data: [String:Any] = [
            "FullName" : ["FirstName": formData.firstName,
                          "MiddleName" : formData.middleName,
                          "LastName" : formData.lastName,
                          "SurName" : formData.surName
                         ],
            "NICNo" : formData.nic,
            "BirthDate" : dateFormatter.string(from: formData.dateOfBirth),
            "Gender" : formData.gender.rawValue,
            "Profession" : formData.profession.rawValue,
            "Address" : [
                "Street1" : formData.street1,
                "Street2" : formData.street2,
                "City" : formData.city,
                "Postcode" : formData.postCode
            ],
            "EmailAddress" : formData.email,
            "PhoneNo" : formData.fullPhoneNo,
            "NICPhoto" : [
                "FrontSide" : nicFrontURL,
                "BackSide" : nicBackURL
            ],
            "ProfilePhoto" : profileURL,
            "DeviceModel" : formData.deviceModel,
            "DocumentID" : currentUserUID,
            "About" : "Hey there! I am using Happening"
        ]
        
        db
            .collection("Users/\(currentUserUID)/PendingApprovalData")
            .document(currentUserUID)
            .setData(data, merge: true) { [weak self] error in
                if error != nil {
                    self?.isPresentedSubmittingErrorAlert = true
                    return
                } else {
                    db.collection("Users").document(currentUserUID).setData([
                        "isApproved": false,
                        "pendingProfilePhotoApproval": false
                    ]) { error in
                        if error != nil {
                            self?.isPresentedSubmittingErrorAlert = true
                            return
                        } else {
                            self?.currentUser.setUserDefaults(type: .isUserSignedOut, value: false)
                            self?.currentUser.setUserDefaults(type: .isExistingUser, value: true)
                            self?.currentUser.setUserDefaults(type: .isApprovedUser, value: false)
                            self?.isPresentedSubmitLoadingView = false
                            self?.isDisabledApprovalForm = false
                            print("Approval Form Has Been Submitted Successfully🥳🥳🥳")
                        }
                    }
                }
            }
    }
    
    // MARK: removeLast
    // remove the invalid last character when typing
    func removeLast(variable: Binding<String>, characterType: CharacterSetType) {
        var characterSet: CharacterSet = .letters
        if(characterType == .alphabetical) {
            characterSet = .letters
        } else if(characterType == .nic) {
            characterSet = validNICCharacterSet
        } else if(characterType == .address) {
            characterSet = .symbols.inverted
        }
        if (variable.wrappedValue.rangeOfCharacter(from: characterSet.inverted) != nil) {
            variable.wrappedValue.removeLast()
            if(characterType == .alphabetical) {
                alertItemForNameListSection = AlertItemModel(title: "Only Alphabetical Characters Are Allowed", message: "")
            } else if(characterType == .nic) {
                alertItemForNICSection = AlertItemModel(title: "Only Numerical and 'V' Characters Are Allowed", message: "ex: 123456789V or 123456789012")
            } else if(characterType == .address) {
                alertItemForAddressListSection = AlertItemModel(title: "Emojis Are Not Allowed", message: "")
            }
        }
    }
    
    // MARK: nameValidation
    // Assign full name to navigation text after name validation
    func nameValidation() {
        
        if(formData.middleName.isEmpty && formData.lastName.isEmpty) {
            formData.fullName = formData.firstName+" "+formData.surName
        } else if(formData.middleName.isEmpty) {
            formData.fullName = formData.firstName+" "+formData.lastName+" "+formData.surName
        } else if(formData.lastName.isEmpty) {
            formData.fullName = formData.firstName+" "+formData.middleName+" "+formData.surName
        } else {
            formData.fullName = formData.firstName+" "+formData.middleName+" "+formData.lastName+" "+formData.surName
        }
        
        if(formData.firstName.count < 3 || formData.surName.count < 3 || (formData.middleName.count < 3 && formData.middleName.count > 0) || (formData.lastName.count < 3 && formData.lastName.count > 0)){
            formData.fullName = "Enter Full Name"
            self.isCompleted = false
        }
        
        self.formData.firstName = self.formData.firstName.localizedCapitalized
        self.formData.middleName = self.formData.middleName.localizedCapitalized
        self.formData.lastName = self.formData.lastName.localizedCapitalized
        self.formData.surName = self.formData.surName.localizedCapitalized
        
        self.enabelSubmitButton()
    }
    
    // MARK: nicNoValidation
    func nicNoValidation() {
        // No more than 12 characters.
        if (formData.nic.count > 12) {
            formData.nic.removeLast()
        }
        // Reject when contains a 'V' and charaters are less than 10.
        if((formData.nic.contains("V") || formData.nic.contains("v")) && formData.nic.count < 10){
            formData.nic.removeLast()
        }
        // Reject when contains a 'V' and charaters are greater than 10.
        if((formData.nic.contains("V") || formData.nic.contains("v")) && formData.nic.count > 10){
            formData.nic.removeLast()
        }
        // All Characters will be upercased when reaches 10 characters.
        if(formData.nic.count == 10) {
            formData.nic = formData.nic.uppercased()
        }
        self.enabelSubmitButton()
    }
    
    //MARK: DateOfBirthValidation
    func DateOfBirthValidation() {
        formData.age = String(Calendar.current.dateComponents([.year], from: formData.dateOfBirth, to: Date()).year ?? 0)
        enabelSubmitButton()
        if(!formData.age.isEmpty){ isChangedAccentColorBirthDate = true }
        else { self.isChangedAccentColorBirthDate = false }
    }
    
    // MARK: addressValidation
    func addressValidation() {
        if(formData.street2.isEmpty) {
            formData.address = formData.street1+", "+formData.city+", "+formData.postCode
        } else {
            formData.address = formData.street1+", "+formData.street2+", "+formData.city+", "+formData.postCode
        }
        if(formData.street1.count < 3 || formData.city.count < 3 || formData.postCode.count < 3 || (formData.street2.count < 3 && formData.street2.count > 0)){
            formData.address = "Add Permanent Address"
            self.isCompleted = false
        }
        
        self.formData.street1 = self.formData.street1.localizedCapitalized
        self.formData.street2 = self.formData.street2.localizedCapitalized
        self.formData.city = self.formData.city.localizedCapitalized
        
        self.enabelSubmitButton()
    }
    
    // MARK: navigationLabelColorUpdator
    func navigationLabelColorUpdator() {
        // change the color of the name navigation label
        if(self.formData.firstName.count > 2 && self.formData.surName.count > 2){
            self.isChangedAccentColorNameField = true
        } else { self.isChangedAccentColorNameField = false }
        // change the color of the address navigation label
        if(self.formData.street1.count > 2 && self.formData.city.count > 2 && self.formData.postCode.count > 2){
            self.isChangedAccentColorAddressField = true
        } else { self.isChangedAccentColorAddressField = false }
    }
    
    // MARK: phoneNoValidation
    func phoneNoValidation() {
        // Remove characters after count of 7.
        if(formData.phoneNo.count == 8){
            formData.phoneNo.removeLast()
        }
        // once the phone number count reaches to 7 the full phone number will be created.
        if(formData.phoneNo.count == 7){
            formData.fullPhoneNo = formData.spCode+formData.phoneNo
            isDisabledVerifyButton = false
        } else {
            isDisabledVerifyButton = true
            isVerified = .verify
        }
        self.enabelSubmitButton()
    }
    
    // MARK: EnableSubmitButton
    // Validate & enabel Submit button
    func enabelSubmitButton() {
        if(formData.firstName.count > 2 && formData.surName.count > 2 && (formData.middleName.count > 2 || formData.middleName.count == 0) && (formData.lastName.count > 2 || formData.lastName.count == 0) && formData.street1.count > 2 && (formData.street2.count > 2 || formData.street2.count == 0) && formData.city.count > 2 && formData.postCode.count > 2 && ((formData.nic.count == 10 && formData.nic.contains("V")) || formData.nic.count == 12) && !formData.age.isEmpty && formData.email.count > 6 && formData.phoneNo.count == 7 && isAddedFrontImage && isAddedBackImage && isAddedProfileImage && isVerified == .verified) {
            isCompleted = true
        } else {
            isCompleted = false
        }
    }
}
