//
//  CurrentUser.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-13.
//

import Foundation
import Firebase
import FirebaseAuth

class CurrentUser: ObservableObject {
    
    // MARK: PROPERTIES
    // singleton
    static let shared = CurrentUser()
    
    // store user uid when signup or signin with social media account, not with phone number
    @Published var currentUserUID: String? = nil
    
    @Published var isUserSignedOut: Bool = true
    @Published var isExistingUser: Bool = false
    @Published var isApprovedUser: Bool = false
    
    enum UserDefaultKeys: String {
        case isUserSignedOut
        case isExistingUser
        case isApprovedUser
        case currentUserUID
    }
    
    // a model that helps to fetch data from one field from the firebase databse
    struct IsApprovedModel {
        let isApproved: Bool
    }
    
    // a firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    // MARK: INITIALIZER
    init() {
        registerUserDefaults()
        getAndSetAllUserDefaults()
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: registerUserDefaults
    func registerUserDefaults() {
        
        let defaults = UserDefaults.standard
        
        defaults.register(defaults: [UserDefaultKeys.isUserSignedOut.rawValue : true])
        defaults.register(defaults: [UserDefaultKeys.isExistingUser.rawValue : false])
        defaults.register(defaults: [UserDefaultKeys.isApprovedUser.rawValue : false])
    }
    
    // MARK: setUserDefaults
    func setUserDefaults(type: UserDefaultKeys, value: Any) {
        
        let defaults =  UserDefaults.standard
        
        switch type {
        case .isUserSignedOut:
            defaults.set(value, forKey: UserDefaultKeys.isUserSignedOut.rawValue)
            isUserSignedOut = defaults.bool(forKey: UserDefaultKeys.isUserSignedOut.rawValue)
            
        case .isExistingUser:
            defaults.set(value, forKey: UserDefaultKeys.isExistingUser.rawValue)
            isExistingUser = defaults.bool(forKey: UserDefaultKeys.isExistingUser.rawValue)
            
        case .isApprovedUser:
            defaults.set(value, forKey: UserDefaultKeys.isApprovedUser.rawValue)
            isApprovedUser = defaults.bool(forKey: UserDefaultKeys.isApprovedUser.rawValue)
            
        case .currentUserUID:
            defaults.set(value, forKey: UserDefaultKeys.currentUserUID.rawValue)
            currentUserUID = defaults.string(forKey: UserDefaultKeys.currentUserUID.rawValue)
        }
    }
    
    // MARK: getUserDefaults
    func getUserDefaults(type: UserDefaultKeys) -> Any {
        
        let defaults = UserDefaults.standard
        
        switch type {
        case .isUserSignedOut:
            return defaults.bool(forKey: UserDefaultKeys.isUserSignedOut.rawValue)
            
        case .isExistingUser:
            return defaults.bool(forKey: UserDefaultKeys.isExistingUser.rawValue)
            
        case .isApprovedUser:
            return defaults.bool(forKey: UserDefaultKeys.isApprovedUser.rawValue)
            
        case .currentUserUID:
            return defaults.string(forKey: UserDefaultKeys.currentUserUID.rawValue) ?? ""
        }
    }
    
    // MARK: getAndSetAllUserDefaults
    func getAndSetAllUserDefaults() {
        
        let defaults =  UserDefaults.standard
        
        isUserSignedOut = defaults.bool(forKey: UserDefaultKeys.isUserSignedOut.rawValue)
        isExistingUser = defaults.bool(forKey: UserDefaultKeys.isExistingUser.rawValue)
        isApprovedUser = defaults.bool(forKey: UserDefaultKeys.isApprovedUser.rawValue)
        currentUserUID = defaults.string(forKey: UserDefaultKeys.currentUserUID.rawValue)
    }
    
    // MARK: resetUserDefaults
    func resetUserDefaults() {
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        setUserDefaults(type: .isUserSignedOut, value: true)
        setUserDefaults(type: .isExistingUser, value: false)
        setUserDefaults(type: .isApprovedUser, value: false)
    }
    
    // MARK: isExistingUser
    func isExistingUser(completionHandler: @escaping (_ data: Bool) -> ()) {
        
        // get user uid from firebase after a successful signin with a social media account
        guard let uid = currentUserUID else { return }
        // reference to firebase firestore
        let db = Firestore.firestore()
        // reference to main document of the current user
        let docRef = db.collection("Users").document(uid)
        
        // get the main document data without fetching sub collection data
        firestoreListener?.remove()
        firestoreListener = docRef.addSnapshotListener { document, error in
            // check whether the document is available or not
            if let document = document {
                // check whether the document is available or not
                if(document.exists) {
                    print("Document Exists For UserUID : \(uid)👍🏻👍🏻👍🏻")
                    print("Document ID: \(document.documentID)🗒🗒🗒")
                    
                    // get isApproved status data form the document
                    guard let isApproved = document.get("isApproved").map({ data in
                        return IsApprovedModel(isApproved: data as! Bool)
                    }) else { return }
                    
                    // print whether the user is approved or not from the fetched result
                    switch isApproved.isApproved {
                    case true:
                        print("Approved User 😎😎😎")
                        
                        // excecute everything that need to be excecuted for one time after the app is installed
                        AppInitializer.shared.firstTimeOnApp()
                        
                    case false:
                        print("User Has Not Been Approved Yet. 😒😒😒")
                    }
                    // save is approved status to user defaults
                    self.setUserDefaults(type: .isApprovedUser, value: isApproved.isApproved)
                    
                    // returns true if the user is exist in the firebase database
                    completionHandler(true)
                } else {
                    // returns false if the user doesn't exist in the firebase database
                    print("Document Is Not Available. 😕😕😕")
                    completionHandler(false)
                }
            }
        }
    }
    
    // MARK: signOutUser
    func signOutUser() {
        
        // signout the user from facebook and/or google on this app
        do {
            try Auth.auth().signOut()
            FacebookLoginManager.shared.facebookLogout()
            GoogleLoginManager.shared.googleSignOut()
        } catch {
            print(error.localizedDescription)
        }
        
        // set userdefaults to it's default states (reset)
        resetUserDefaults()
        
        // set default color theme (reset)
        ColorTheme.shared.resetThemeColor()
        
        // disable faceID
        FaceIDAuthentication.shared.resetFaceID()
        
        // reset approval form
        ApprovalFormViewModel.shared.resetApprovalForm()
        
        // hide progress view in sigin view
        SignInViewModel.shared.isPresentedLoadingView = false
    }
}
