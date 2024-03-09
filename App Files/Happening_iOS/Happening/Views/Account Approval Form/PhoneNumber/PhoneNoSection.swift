//
//  PhoneNoSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import SwiftUI

struct PhoneNoSection: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    @EnvironmentObject var phoneNoAuthManager: PhoneNoAuthManager
    
    // controls the state of the email address field
    @FocusState.Binding var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    // MARK: BODY
    var body: some View {
        HStack {
            Picker("Service Provider Code",selection: $approvalFormViewModel.formData.spCode) {
                ForEach(ServiceProviders.allCases, id: \.self) { type in
                    Text(type.rawValue)
                        .tag(type.rawValue)
                }
            }
            .pickerStyle(.menu)
            
            TextField("Phone No", text: $approvalFormViewModel.formData.phoneNo)
                .focused($fieldInFocus, equals: .phoneNo)
                .keyboardType(.asciiCapableNumberPad)
                .onChange(of: approvalFormViewModel.formData.phoneNo) { _ in
                    approvalFormViewModel.phoneNoValidation()
                }
            
            // verify  button
            Button {
                hideKeyboard()
                
                approvalFormViewModel.isDisabledApprovalForm = true
                approvalFormViewModel.isPresentedLoadingView = true
                
                phoneNoAuthManager.phoneNumber = approvalFormViewModel.formData.fullPhoneNo
                
                phoneNoAuthManager.sendVerificationCode { returnedStatus, error  in
                    if(returnedStatus == .success) {
                        approvalFormViewModel.isPresentedPhoneNoVerificationSheet = true
                    } else {
                        approvalFormViewModel.alertItemForPhoneNoSection = AlertItemModel(title: "Unable to Send Verification Code", message: error?.localizedDescription ?? "Please check your number and try again later.")
                    }
                }
            } label: {
                Text(approvalFormViewModel.isVerified.rawValue)
                    .foregroundColor(approvalFormViewModel.isVerified == .verified ? .green : .accentColor)
            }
            .disabled(approvalFormViewModel.isDisabledVerifyButton)
            .alert(item: $approvalFormViewModel.alertItemForPhoneNoSection) { alert -> Alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message)
                )
            }
        }
    }
}

// MARK: PREVIEW
struct PhoneNoSection_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: ApprovalFormViewModel.FieldType?
    
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    Section{
                        PhoneNoSection(fieldInFocus: $fieldInFocus)
                            .preferredColorScheme(.dark)
                    }
                }
            }
            NavigationView {
                Form {
                    Section{
                        PhoneNoSection(fieldInFocus: $fieldInFocus)
                    }
                }
            }
        }
        .environmentObject(ApprovalFormViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(PhoneNoAuthManager())
        .environmentObject(EditPhoneNumberViewModel())
    }
}
