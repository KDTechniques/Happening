//
//  EditEmailAddressView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-02.
//

import SwiftUI

struct EditEmailAddressView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var editEmailAddressViewModel: EditEmailAddressViewModel
    
    // MARK: BODY
    var body: some View {
        List {
            // email address
            Section {
                TextField("", text: $editEmailAddressViewModel.emailTextFieldText)
                    .onChange(of: editEmailAddressViewModel.emailTextFieldText) { _ in
                        editEmailAddressViewModel.emailAddressTextFieldValidation()
                    }
            } header: {
                Text("Edit Email Address")
                    .font(.footnote)
            }
            
            // verify button
            Section {
                HStack {
                    Spacer()
                    
                    Button("Verify Email Address") {
                        if(!isValidEmail(email: editEmailAddressViewModel.emailTextFieldText)) {
                            editEmailAddressViewModel.alertItemForEditEmailAddressView = AlertItemModel(title: "Invalid Email Address", message: "")
                        } else {
                            editEmailAddressViewModel.isPresentedEmailVerificationSheet = true
                        }
                    }
                    .disabled(editEmailAddressViewModel.isDisabledVerifyEmailAddressButton)
                    
                    Spacer()
                }
            } footer: {
                Text("You will receive a \(Text("Verification PIN").fontWeight(.semibold)) to verify the entered email address belongs to you.")
                    .font(.footnote)
            }
            .sheet(isPresented: $editEmailAddressViewModel.isPresentedEmailVerificationSheet) {
                EmailOTPSheetView()
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Email Address"))
        .onAppear {
            editEmailAddressViewModel.getEmailAddressFromFirestore()
        }
        .alert(item: $editEmailAddressViewModel.alertItemForEditEmailAddressView) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        }
    }
}

// MARK: PREVIEWS
struct EditEmailAddressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditEmailAddressView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                EditEmailAddressView()
            }
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(EditEmailAddressViewModel())
    }
}
