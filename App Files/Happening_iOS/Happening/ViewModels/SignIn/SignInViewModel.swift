//
//  SignInViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-24.
//

import Foundation
import FBSDKLoginKit
import Firebase

class SignInViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = SignInViewModel()
    
    // reference to ApprovalFormViewModel class object
    let approvalFormViewModel = ApprovalFormViewModel.shared
    
    // reference to FacebookLoginManager class object
    let fbLoginManager = FacebookLoginManager.shared
    
    // reference to GoogleLoginManager class object
    let googleLoginManager = GoogleLoginManager.shared
    
    // reference to CurrentUser class object
    let currentUser = CurrentUser.shared
    
    // app color name
    let appColor: String = "AppColor"
    
    // sign in button label names
    enum ButtonLabel: String {
        case facebook = "Log in with Facebook"
        case google = "Continue with Google"
        case apple = "Sign in with Apple"
    }
    
    // sign in button image names
    enum ButtonImage: String {
        case facebook = "FacebookLogo"
        case google = "GoogleLogo"
        case apple = "AppleLogo"
    }
    
    // controls alert for the SignIn View
    @Published var alertForSignInView: AlertItemModel?
    
    // controls the loading progress when login to a social networking account
    @Published var isPresentedLoadingView: Bool = false
    
    // MARK: FUNCTIONS
    // MARK: loginInWithFacebook
    func loginInWithFacebook() {
        fbLoginManager.facebookLogin()
    }
    
    // MARK: continueWithGoogle
    func continueWithGoogle() {
        googleLoginManager.googleSignIn()
    }
    
    // MARK: signInWithApple
    func signInWithApple(){
        // code goes here...
    }
}
