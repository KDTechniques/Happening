//
//  UpdateProfessionViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class UpdateProfessionViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = UpdateProfessionViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // controls progress view of the profession editing list
    @Published var showProgressViewInEditProfessionView: Bool = false
    
    // present an alert item for the UpdateProfessionView
    @Published var alertItemForUpdateProfessionView: AlertItemModel?
    
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: updateProfessionInFirebase
    func updateProfessionInFirebase(profession: String?) {
        
        guard
            let docID = currentUser.currentUserUID,
            let profession = profession else {
                self.alertItemForUpdateProfessionView = AlertItemModel(title: "Unable to Update Profession", message: "Please, try again in a moment.")
                return
            }
        
        db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .updateData(["Profession":profession]) { error in
                if let error =  error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("Profession Has Been Updated Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                    self.defaults.set(profession, forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.profession.rawValue)
                    self.showProgressViewInEditProfessionView = false
                }
            }
        
    }
}
