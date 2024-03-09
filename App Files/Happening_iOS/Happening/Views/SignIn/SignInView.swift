//
//  SignInView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-13.
//

import SwiftUI
import FirebaseFirestore

struct SignInView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var currentUser: CurrentUser
    
    @State private var isPresentedLoadingView: Bool = false
    @State private var count: Int = 0
    
    // MARK: BODY
    var body: some View {
        siginInView
    }
}

// MARK: PREVIEWS
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView().preferredColorScheme(.dark)
            SignInView()
        }
        .environmentObject(ApprovalFormViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(SignInViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(CurrentUser())
    }
}

// MARK: COMPONENTS
private extension SignInView {
    
    // MARK: siginInView
    private var siginInView: some View {
        VStack {
            Spacer()
            title_headline_subheadline
            Spacer()
            VStack(spacing: 10){
                loginInWithFacebookButton
                continueWithGoogleButton
                signInWithAappleButton
            }
            Spacer()
            Spacer()
            Spacer()
            termsAndConditionsText
        }
        .padding()
        .padding(.horizontal, 20)
        .overlay(alignment: .center) {
            if(signInViewModel.isPresentedLoadingView) {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 50, height: 50)
                    .overlay(
                        ProgressView()
                            .tint(.primary)
                    )
            }
        }
        .disabled(signInViewModel.isPresentedLoadingView)
        .alert(item: $signInViewModel.alertForSignInView) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        }
    }
    
    // MARK: title_headline_subheadline
    private var title_headline_subheadline: some View {
        HStack {
            VStack(alignment: .leading) {
                Image("LogoText")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .padding(.bottom, 18)
                
                Text("Meet . Learn . Earn")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 6)
                
                Text("Earn and learn while doing things.")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.title.weight(.semibold))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: loginInWithFacebookButton
    private var loginInWithFacebookButton: some View {
        Button {
            signInViewModel.loginInWithFacebook()
        } label: {
            SignInButtonView(buttonModel: .init(imageName: SignInViewModel.ButtonImage.facebook.rawValue, renderingMode: .original, imageColorLight: .white, imageColorDark: .white, text: SignInViewModel.ButtonLabel.facebook.rawValue, backgroundColor: Color("FacebookColor"), chevronColorLight: .white, chevronColorDark: .white))
        }
    }
    
    //MARK: continueWithGoogleButton
    private var continueWithGoogleButton: some View {
        Button {
            signInViewModel.continueWithGoogle()
        } label: {
            SignInButtonView(buttonModel: .init(imageName: SignInViewModel.ButtonImage.google.rawValue, renderingMode: .original, imageColorLight: .clear, imageColorDark: .clear, text: SignInViewModel.ButtonLabel.google.rawValue, backgroundColor: .white, chevronColorLight: Color(UIColor.systemGray2), chevronColorDark: Color(UIColor.systemGray2)))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(Color.secondary.opacity(colorScheme == .light ? 1 : .zero))
                )
        }
    }
    
    //MARK: signInWithAappleButton
    private var signInWithAappleButton: some View {
        VStack(alignment: .leading) {
            Button {
                // you need a developer account to implement "Signin with Apple"
                // code goes here...
            } label: {
                SignInButtonView(buttonModel: .init(imageName: SignInViewModel.ButtonImage.apple.rawValue, renderingMode: .template, imageColorLight: .white, imageColorDark: .black, text: SignInViewModel.ButtonLabel.apple.rawValue, backgroundColor: .primary, chevronColorLight: .white, chevronColorDark: .black))
            }
            
            note
        }
    }
    
    // MARK: note
    private var note: some View {
        Text("\(Text("Note: ").fontWeight(.bold))You must be 16+ to sign in with any social networking platform listed above.")
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading, 6)
            .font(.caption2)
            .foregroundColor(Color.secondary)
    }
    
    //MARK: termsAndConditionsText
    private var termsAndConditionsText: some View {
        Text("By using this app, you agree to the \(Text("[Terms and Conditions](https://example.com)").foregroundColor(Color.primary)) and \(Text("[Privacy Policy](https://example.com)")). You may also agree to receive product-related emails from Happening from which you can unsbscribe at any time.")
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .font(.custom("terms&ConditionsFont", size: 10))
            .foregroundColor(Color.secondary)
    }
}
