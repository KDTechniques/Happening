//
//  ProfileBasicInfoViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class ProfileBasicInfoViewModel: ObservableObject {
    
    // MARK: PROPETIES
    // singleton
    static let shared = ProfileBasicInfoViewModel()
    
    let db = Firestore.firestore()
    
    @Published var basicProfileDataArray = [BasicProfileInfoModel]()
    
    enum ProfileBasicInfoUserDefaultsType: String {
        case userName
        case about
        case profession
    }
    
    // reference to User Defaults
    let defaults = UserDefaults.standard
    
    // firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    @Published var profilePhotoUserDefaultsKeyName: String = "ProfilePhoto"
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getBasicProfileDataFromFirestore
    func getBasicProfileDataFromFirestore(completion: @escaping (_ status: Bool) -> ()) {
        
        guard let docID = CurrentUser.shared.currentUserUID else { return }
        
        firestoreListener?.remove()
        firestoreListener = db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                } else {
                    
                    guard  let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                        print("either document snapshot nil, or it doesn't exsist.")
                        return
                    }
                    
                    guard let data = documentSnapshot.data() else {
                        print("document snapshot has no data.")
                        completion(false)
                        return
                    }
                    
                    let object1 = BasicProfileInfoModel(data: data)
                    let object2 = EditProfileModel(data: data)
                    
                    self.basicProfileDataArray.removeAll() // for safty reasons
                    self.basicProfileDataArray.append(object1)
                    
                    EditProfileViewModel.shared.editProfileDataArray.removeAll() // for safty reasons
                    EditProfileViewModel.shared.editProfileDataArray.append(object2)
                    
                    self.checkUserDefaults(type: .userName)
                    self.checkUserDefaults(type: .about)
                    self.checkUserDefaults(type: .profession)
                    
                    EditProfileViewModel.shared.saveToUserDefaults(type: .fullName)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .firstName)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .middleName)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .lastName)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .surName)
                    
                    EditProfileViewModel.shared.saveToUserDefaults(type: .address)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .street1)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .street2)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .city)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .postcode)
                    
                    EditProfileViewModel.shared.saveToUserDefaults(type: .phoneNo)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .email)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .nicNo)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .dateOfBirth)
                    EditProfileViewModel.shared.saveToUserDefaults(type: .gender)
                    
                    print("Basic Profile Data Has Been Retrieved Successfully. 🤓🤓🤓")
                    completion(true)
                }
            }
    }
    
    // MARK: checkUserDefaults
    func checkUserDefaults(type: ProfileBasicInfoUserDefaultsType) {
        switch type {
        case .userName:
            saveToUserDefaults(type: .userName)
            
        case .about:
            saveToUserDefaults(type: .about)
            
        case .profession:
            saveToUserDefaults(type: .profession)
        }
        
    }
    
    // MARK: saveToUserDefaults
    func saveToUserDefaults(type: ProfileBasicInfoUserDefaultsType) {
        switch type {
        case .userName:
            defaults.set(basicProfileDataArray[0].userName, forKey: ProfileBasicInfoUserDefaultsType.userName.rawValue)
            
        case .about:
            defaults.set(basicProfileDataArray[0].about, forKey: ProfileBasicInfoUserDefaultsType.about.rawValue)
            
        case .profession:
            defaults.set(basicProfileDataArray[0].profession, forKey: ProfileBasicInfoUserDefaultsType.profession.rawValue)
        }
    }
}
