//
//  FacebookLoginManager.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-04.
//

import Foundation
import FBSDKLoginKit
import Firebase

class FacebookLoginManager: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = FacebookLoginManager()
    // reference to facebook login manager
    let loginManager = LoginManager()
    // reference to AuthenticatedUserViewModel class object
    let authenticatedUserViewModel = AuthenticatedUserViewModel.shared
    // reference to ApprovalFormViewModel class object
    let approvalFormViewModel = ApprovalFormViewModel.shared
    // reference to CurrentUser class object
    let currentUser =  CurrentUser.shared
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: facebookLogin
    func facebookLogin() {
        
        loginManager.logIn(permissions: [.publicProfile], viewController: nil) { [weak self] loginResult in
            switch loginResult {
            case .success:
                guard let token = AccessToken.current?.tokenString else { return }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        self?.facebookLogout()
                        
                        if(error.localizedDescription.contains("The user account has been disabled by an administrator.")) {
                            print("Your Account Has Been Banned by The Happening!")
                            SignInViewModel.shared.alertForSignInView = AlertItemModel(title: "Account Banned", message: "Your Happening account has been banned for violating our terms.")
                        } else {
                            SignInViewModel.shared.alertForSignInView = AlertItemModel(title: "Unable to Sign In", message: error.localizedDescription)
                        }
                        return
                    }
                    
                    print(Auth.auth().currentUser?.photoURL as Any)
                    if
                        let userUID = Auth.auth().currentUser?.uid,
                        let fbUserPhotoURL = authResult?.user.photoURL,
                        let fbUserName = authResult?.user.displayName {
                        
                        SignInViewModel.shared.isPresentedLoadingView = true
                        
                        print("Facebook Authentication Successful 🥳🥳🥳")
                        
                        self?.currentUser.setUserDefaults(type: .currentUserUID, value: userUID)
                        
                        self?.currentUser.isExistingUser(completionHandler: { returnedBool in
                            self?.currentUser.setUserDefaults(type: .isUserSignedOut, value: false)
                            self?.currentUser.setUserDefaults(type: .isExistingUser, value: returnedBool)
                        })
                        
                        self?.authenticatedUserViewModel.userData = AuthenticatedUserModel(userImage: URL(string: "\(String(describing: fbUserPhotoURL))?type=large")!, userName: fbUserName)
                    }
                }
            case .cancelled:
                print("Facebook Login Cancelled!")
            case .failed(_):
                print("Facebook Login Failed!")
                SignInViewModel.shared.alertForSignInView = AlertItemModel(title: "Unable to Sign In", message: "Login to FaceBook has been failed.")
            }
        }
    }
    
    // MARK: facebookLogout
    func facebookLogout() {
        self.loginManager.logOut()
    }
}
