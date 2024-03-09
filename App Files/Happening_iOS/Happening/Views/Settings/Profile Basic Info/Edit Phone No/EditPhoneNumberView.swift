//
//  EditPhoneNumber.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-31.
//

import SwiftUI

struct EditPhoneNumberView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var editPhoneNumberViewModel: EditPhoneNumberViewModel
    @EnvironmentObject var otpSheetViewModel: OTPSheetViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // MARK: BODY
    var body: some View {
        List {
            // phone number
            Section {
                TextField("required", text: $editPhoneNumberViewModel.phoneNumberTextFieldText)
                    .disabled(editPhoneNumberViewModel.isDisabledPhoneNoTextField)
                    .keyboardType(.asciiCapableNumberPad)
                    .onChange(of: editPhoneNumberViewModel.phoneNumberTextFieldText) { _ in
                        editPhoneNumberViewModel.validatePhoneNo()
                    }
            } header: {
                Text("Edit Phone Number")
                    .font(.footnote)
            } footer: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("You must enter the 10 digits phone number of this device.")
                    
                    Text("Verifying the entered phone number on another device may lead to an account ban.")
                }
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
            }
            
            // verify button
            Section {
                HStack {
                    Spacer()
                    
                    Button("Verify Phone Number") {
                        hideKeyboard()
                        if(networkManager.connectionStatus == .connected) {
                            editPhoneNumberViewModel.isPresentedLoadingProgress = true
                            editPhoneNumberViewModel.onClickVerifyButton()
                        } else {
                            editPhoneNumberViewModel.alertItemForEditPhoneNumberView = AlertItemModel(
                                title: "Couldn't Verify Phone Number", message: "Check you phone's connection and try again."
                            )
                        }
                    }
                    .disabled(editPhoneNumberViewModel.isDisabledVerifyPhoneNumberButton)
                    
                    Spacer()
                }
            } footer: {
                Text("You will receive a \(Text("Verification PIN SMS").fontWeight(.semibold)) to verify the entered phone number belongs to you.")
                    .font(.footnote)
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(editPhoneNumberViewModel.isPresentedLoadingProgress) {
                    CustomProgressView1(text: Binding.constant("Loading..."))
                } else {
                    
                    Text("Phone Number")
                        .fontWeight(.semibold)
                }
            }
        }
        .alert(item: $editPhoneNumberViewModel.alertItemForEditPhoneNumberView, content: { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        })
        .onAppear {
            editPhoneNumberViewModel.getPhoneNumberFromFirestore()
        }
        .sheet(isPresented: $editPhoneNumberViewModel.isPresentedPhoneNoVerificationSheet, onDismiss: {
            otpSheetViewModel.resetOTPTextFields()
            editPhoneNumberViewModel.isPresentedLoadingProgress = false
        }, content: { PhoneNoOTPSheetView() })
    }
}

// MARK: PREVIEWS
struct EditPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditPhoneNumberView()
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                EditPhoneNumberView()
            }
        }
        .environmentObject(EditPhoneNumberViewModel())
        .environmentObject(OTPSheetViewModel())
        .environmentObject(NetworkManger())
    }
}
