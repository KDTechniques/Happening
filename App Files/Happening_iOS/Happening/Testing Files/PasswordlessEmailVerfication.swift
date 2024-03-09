//
//  PasswordlessEmailVerfication.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-14.
//

import SwiftUI
import Firebase

struct PasswordlessEmailVerfication: View {
    @State private var email: String = ""
    @State private var isPresentingSheet = false
    
    @State private var alertItem: AlertItem? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Authenticate users with only their email, no password required!")
                    .padding(.bottom, 60)
                
                CustomStyledTextField(
                    text: $email, placeholder: "Email", symbolName: "person.circle.fill"    // 1
                )
                
                CustomStyledButton(title: "Send Sign In Link", action: sendSignInLink)    // 2
                    .disabled(email.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Passwordless Login")
        }
        .onOpenURL { url in   // 2
            let link = url.absoluteString
            if Auth.auth().isSignIn(withEmailLink: link) {    // 3
                passwordlessSignIn(email: email, link: link) { result in    // 4
                    switch result {
                    case let .success(user):
                        isPresentingSheet = user?.isEmailVerified ?? false
                    case let .failure(error):
                        isPresentingSheet = false
                        alertItem = AlertItem(
                            title: "An authentication error occurred.",
                            message: error.localizedDescription
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingSheet) {   // 5
            VStack {
                Text(email)
                    .font(.largeTitle)
                    .padding()
            }
        }
        .alert(item: $alertItem) { alert -> Alert in    // *
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        }
    }
    
    private func sendSignInLink() {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(
            string: "https://kdtechniques.page.link/passwordless_email_verification"    // 1
        )
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email,
                                   actionCodeSettings: actionCodeSettings) { error in   // 2
            if let error = error {
                alertItem = AlertItem(
                    title: "The sign in link could not be sent.",
                    message: error.localizedDescription
                )
            }
        }
    }
    
    private func passwordlessSignIn(email: String, link: String,
                                    completion: @escaping (Result<User?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, link: link) { result, error in
            if let error = error {
                print("ⓧ Authentication error: \(error.localizedDescription).")
                completion(.failure(error))
            } else {
                print("✔ Authentication was successful.")
                completion(.success(result?.user))
            }
        }
    }
    
}

struct PasswordlessEmailVerfication_Previews: PreviewProvider {
    static var previews: some View {
        PasswordlessEmailVerfication()
    }
}

struct CustomStyledTextField: View {
    @Binding var text: String
    let placeholder: String
    let symbolName: String
    
    var body: some View {
        HStack {
            Image(systemName: symbolName)
                .imageScale(.large)
                .padding(.leading)
            
            TextField(placeholder, text: $text)
                .padding(.vertical)
                .accentColor(.orange)
                .autocapitalization(.none)
        }
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .circular)
                .foregroundColor(Color(.secondarySystemFill))
        )
    }
}

struct CustomStyledButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .padding()
                    .accentColor(.white)
                Spacer()
            }
        }
        .background(Color.orange)
        .cornerRadius(16.0)
    }
}

struct AlertItem: Identifiable {
    var id = UUID()
    var title: String
    var message: String
}
