//
//  ApprovalFormPhoneNoOTPSheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-10.
//

import SwiftUI

struct ApprovalFormPhoneNoOTPSheetView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var phoneNoAuthManger: PhoneNoAuthManager
    @EnvironmentObject var otpSheetViewModel: OTPSheetViewModel
    @EnvironmentObject var approvalFormViewModel: ApprovalFormViewModel
    
    // MARK: BODY
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(.secondary)
                    .frame(width: 80, height: 4)
                    .padding()
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Button {
                        approvalFormViewModel.isPresentedPhoneNoVerificationSheet = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            otpSheetViewModel.resetOTPTextFields()
                        }
                    } label: {
                        Text("Cancel")
                            .padding()
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            OTPSheetView(verificationSentTo: $phoneNoAuthManger.phoneNumber, verificationType: Binding.constant(.phoneNo), isPresentedOTPSheet: $approvalFormViewModel.isPresentedPhoneNoVerificationSheet, isVerfied: $approvalFormViewModel.isVerified)
        }
        .onDisappear {
            otpSheetViewModel.resetOTPTextFields()
        }
    }
}

struct ApprovalFormPhoneNoOTPSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ApprovalFormPhoneNoOTPSheetView().preferredColorScheme(.dark)
            ApprovalFormPhoneNoOTPSheetView()
        }
        .environmentObject(ColorTheme())
        .environmentObject(PhoneNoAuthManager())
        .environmentObject(OTPSheetViewModel())
        .environmentObject(ApprovalFormViewModel())
    }
}
