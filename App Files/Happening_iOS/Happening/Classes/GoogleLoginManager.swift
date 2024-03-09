//
//  GoogleLoginManager.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-05.
//

import Foundation
import Firebase
import GoogleSignIn
import SwiftUI

class GoogleLoginManager: ObservableObject {
    
    // MARK: PROPERTIES
    // singleton
    static let shared = GoogleLoginManager()
    // reference to AuthenticatedUserViewModel class object
    let authenticatedUserViewModel = AuthenticatedUserViewModel.shared
    // reference to ApprovalFormViewModel class object
    let approvalFormViewModel = ApprovalFormViewModel.shared
    // reference to CurrentUser class object
    let currentUser =  CurrentUser.shared
    
    // MARK: FUNCTOINS
    
    
    
    // MARK: googleSignIn
    func googleSignIn() {
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                self.authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
    
    // MARK: authenticateUser
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            
            if let error = error {
                print(error.localizedDescription)
                self?.googleSignOut()
                
                if(error.localizedDescription.contains("The user account has been disabled by an administrator.")) {
                    print("Your Account Has Been Banned by The Happening!")
                    SignInViewModel.shared.alertForSignInView = AlertItemModel(title: "Account Banned", message: "Your Happening account has been banned for violating our terms.")
                } else {
                    SignInViewModel.shared.alertForSignInView = AlertItemModel(title: "Unable to Sign In", message: error.localizedDescription)
                }
                return
            }
            
            if
                let userUID = Auth.auth().currentUser?.uid,
                let googleUserPhotoURL = authResult?.user.photoURL,
                let googleUserName = authResult?.user.displayName {
                
                SignInViewModel.shared.isPresentedLoadingView = true
                
                print("Google Authentication Successful 🥳🥳🥳")
                
                self?.currentUser.setUserDefaults(type: .currentUserUID, value: userUID)
                
                self?.currentUser.isExistingUser(completionHandler: { returnedBool in
                    self?.currentUser.setUserDefaults(type: .isUserSignedOut, value: false)
                    self?.currentUser.setUserDefaults(type: .isExistingUser, value: returnedBool)
                })
                
                self?.authenticatedUserViewModel.userData = AuthenticatedUserModel(userImage: URL(string: "\(String(describing: googleUserPhotoURL).dropLast(4))200")!, userName: googleUserName)
            }
        }
    }
    
    // MARK: googleSignOut
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
