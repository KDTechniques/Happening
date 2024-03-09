//
//  EditProfileViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-20.
//

import Foundation

class EditProfileViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    //singleton
    static let shared = EditProfileViewModel()
    
    @Published var editProfileDataArray = [EditProfileModel]()
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    enum EditProfileViewUserDefaultsType: String {
        case fullName
        case firstName
        case middleName
        case lastName
        case surName
        
        case address
        case street1
        case street2
        case city
        case postcode
        
        case phoneNo
        case email
        case nicNo
        case dateOfBirth
        case gender
    }
    
    // MARK: FUNCTIONS
    
    
    // MARK: saveToUserDefaults
    func saveToUserDefaults(type: EditProfileViewUserDefaultsType) {
        switch type {
        case .fullName:
            defaults.set(editProfileDataArray[0].fullName, forKey: EditProfileViewUserDefaultsType.fullName.rawValue)
            
        case .firstName:
            defaults.set(editProfileDataArray[0].firstName, forKey: EditProfileViewUserDefaultsType.firstName.rawValue)
            
        case .middleName:
            defaults.set(editProfileDataArray[0].middleName, forKey: EditProfileViewUserDefaultsType.middleName.rawValue)
            
        case .lastName:
            defaults.set(editProfileDataArray[0].lastName, forKey: EditProfileViewUserDefaultsType.lastName.rawValue)
            
        case .surName:
            defaults.set(editProfileDataArray[0].surName, forKey: EditProfileViewUserDefaultsType.surName.rawValue)
            
            
            
        case .address:
            defaults.set(editProfileDataArray[0].address, forKey: EditProfileViewUserDefaultsType.address.rawValue)
            
        case .street1:
            defaults.set(editProfileDataArray[0].street1, forKey: EditProfileViewUserDefaultsType.street1.rawValue)
            
        case .street2:
            defaults.set(editProfileDataArray[0].street2, forKey: EditProfileViewUserDefaultsType.street2.rawValue)
            
        case .city:
            defaults.set(editProfileDataArray[0].city, forKey: EditProfileViewUserDefaultsType.city.rawValue)
            
        case .postcode:
            defaults.set(editProfileDataArray[0].postcode, forKey: EditProfileViewUserDefaultsType.postcode.rawValue)
            
            
            
        case .phoneNo:
            defaults.set(editProfileDataArray[0].phoneNo, forKey: EditProfileViewUserDefaultsType.phoneNo.rawValue)
            
        case .email:
            defaults.set(editProfileDataArray[0].email, forKey: EditProfileViewUserDefaultsType.email.rawValue)
            
        case .nicNo:
            defaults.set(editProfileDataArray[0].nicNo, forKey: EditProfileViewUserDefaultsType.nicNo.rawValue)
            
        case .dateOfBirth:
            defaults.set(editProfileDataArray[0].dateOfBirth, forKey: EditProfileViewUserDefaultsType.dateOfBirth.rawValue)
            
        case .gender:
            defaults.set(editProfileDataArray[0].gender, forKey: EditProfileViewUserDefaultsType.gender.rawValue)
        }
    }
}
