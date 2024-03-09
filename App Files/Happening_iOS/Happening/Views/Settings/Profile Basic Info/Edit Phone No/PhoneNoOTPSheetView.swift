//
//  PhoneNoOTPSheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-01.
//

import SwiftUI

struct PhoneNoOTPSheetView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var editPhoneNumberViewModel: EditPhoneNumberViewModel
    @EnvironmentObject var otpSheetViewModel: OTPSheetViewModel
    @EnvironmentObject var phoneNoAuthmanager: PhoneNoAuthManager
    
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
                        editPhoneNumberViewModel.isPresentedPhoneNoVerificationSheet = false
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
            
            OTPSheetView(verificationSentTo: $phoneNoAuthmanager.phoneNumber, verificationType: Binding.constant(.phoneNo), isPresentedOTPSheet: $editPhoneNumberViewModel.isPresentedPhoneNoVerificationSheet, isVerfied: $editPhoneNumberViewModel.isVerfiedPhoneNo)
        }
        .onDisappear {
            otpSheetViewModel.resetOTPTextFields()
        }
    }
}

// MARK: PREVIEWS
struct OTPSheetContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhoneNoOTPSheetView().preferredColorScheme(.dark)
            PhoneNoOTPSheetView()
        }
        .environmentObject(ColorTheme())
        .environmentObject(EditPhoneNumberViewModel())
        .environmentObject(OTPSheetViewModel())
    }
}
