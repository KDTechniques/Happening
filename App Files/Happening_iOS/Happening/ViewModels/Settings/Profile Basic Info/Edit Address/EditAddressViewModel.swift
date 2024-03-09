//
//  EditAddressViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class EditAddressViewModel: ObservableObject{
    
    // MARK: PROPERTIES
    
    //singleton
    static let shared = EditAddressViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // reference to address model
    @Published var addressData = AddressModel(data: ["":""])
    
    // present an alert for EditAddressView
    @Published var alertItemForEditAddressView:  AlertItemModel?
    
    // present a progress view while updating the address to firestore
    @Published var isPresentedUpdatingProgress: Bool = false
    
    // firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getAddressFromUserDefaults
    func getAddressFromUserDefaults() {
        addressData.street1 = defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.street1.rawValue) ?? ""
        addressData.street2 = defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.street2.rawValue) ?? ""
        addressData.city = defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.city.rawValue) ?? ""
        addressData.postCode = defaults.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.postcode.rawValue) ?? ""
    }
    
    // MARK: getUserNameData
    func getAddressDataFromFirestore() {
        
        guard let docID = currentUser.currentUserUID else { return }
        
        firestoreListener?.remove()
        firestoreListener = db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    
                    guard let document = snapshot  else { return }
                    
                    guard let data = document.data() else { return }
                    
                    let object = AddressModel(data: data)
                    
                    self.addressData = object
                    
                    let address: String = "\(object.street1), \(object.street2), \(object.city) \(object.postCode)".replacingOccurrences(of: ", ,", with: ",")
                    
                    self.saveToUserDefaults(addressData: object, address: address)
                    
                    print("Address Has Been Fetched From Firestore Successfully. 👍🏻👍🏻👍🏻")
                }
            }
    }
    
    // MARK: clearAllAddressFields
    func clearAllAddressFields() {
        
        // this will remove all the texts in the address fields
        addressData.street1 = ""
        addressData.street2 = ""
        addressData.city = ""
        addressData.postCode = ""
    }
    
    // MARK: removeLastAndCapitalizedAddress
    func removeLastAndCapitalizedAddress(variable: Binding<String>) {
        // remove the invalid last character when typing
        if (variable.wrappedValue.rangeOfCharacter(from: .symbols.inverted.inverted) != nil) {
            // remove last characters when it's invalid
            variable.wrappedValue.removeLast()
            
            alertItemForEditAddressView = AlertItemModel(title: "Emojis Are Not Allowed", message: "")
        }
        
        addressData.street1 = addressData.street1.localizedCapitalized
        addressData.street2 = addressData.street2.localizedCapitalized
        addressData.city = addressData.city.localizedCapitalized
    }
    
    // MARK: updateAddressInFirestore
    func updateAddressInFirestore() {
        
        if(addressData.street1.count < 3 || addressData.city.count < 3 || addressData.postCode.count < 3 || (addressData.street2.count < 3 && addressData.street2.count > 0)) {
            
            isPresentedUpdatingProgress = false
            alertItemForEditAddressView = AlertItemModel(title: "An Address Field Must Have At Least Two Characters", message: "")
        } else {
            
            guard let docID = currentUser.currentUserUID else {
                isPresentedUpdatingProgress = false
                alertItemForEditAddressView = AlertItemModel(title: "Unable To Update Address", message: "Please try again in a moment.")
                return
            }
            
            let data: [String: Any] = [
                "Address" : ["Street1" : addressData.street1,
                             "Street2" : addressData.street2,
                             "City" : addressData.city,
                             "Postcode" : addressData.postCode
                            ]
            ]
            
            db
                .collection("Users/\(docID)/ProfileData")
                .document(docID)
                .updateData(data) { error in
                    if let error  = error {
                        print(error.localizedDescription)
                        self.isPresentedUpdatingProgress = false
                        self.alertItemForEditAddressView = AlertItemModel(title: "Unable To Update Address", message: "Please try again in a moment.")
                    } else {
                        let address: String = "\(self.addressData.street1), \(self.addressData.street2), \(self.addressData.city) \(self.addressData.postCode)".replacingOccurrences(of: ", ,", with: ",")
                        
                        self.saveToUserDefaults(addressData: self.addressData, address: address)
                        
                        print("Address Has Been Updated Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                        self.isPresentedUpdatingProgress = false
                        self.alertItemForEditAddressView = AlertItemModel(title: "Address Update Successful", message: "")
                    }
                }
        }
    }
    
    func saveToUserDefaults(addressData: AddressModel?, address: String) {
        
        self.defaults.set(self.addressData.street1, forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.street1.rawValue)
        self.defaults.set(self.addressData.street2, forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.street2.rawValue)
        self.defaults.set(self.addressData.city, forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.city.rawValue)
        self.defaults.set(self.addressData.postCode, forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.postcode.rawValue)
        self.defaults.set(address, forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.address.rawValue)
    }
}
