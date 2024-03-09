//
//  EmailOTPSheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-02.
//

import SwiftUI

struct EmailOTPSheetView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var editEmailAddressViewModel: EditEmailAddressViewModel
    
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
                        editEmailAddressViewModel.isPresentedEmailVerificationSheet = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            editEmailAddressViewModel.resetEmailAddressView()
                        }
                    } label: {
                        Text("Cancel")
                            .padding()
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            OTPSheetView(verificationSentTo: $editEmailAddressViewModel.emailTextFieldText, verificationType: Binding.constant(.email), isPresentedOTPSheet: $editEmailAddressViewModel.isPresentedEmailVerificationSheet, isVerfied: $editEmailAddressViewModel.isVerfiedEmailAddress)
        }
        .onDisappear {
            editEmailAddressViewModel.resetEmailAddressView()
        }
    }
}

// MARK: PREVIEWS
struct EmailOTPSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmailOTPSheetView()
                .preferredColorScheme(.dark)
            
            EmailOTPSheetView()
        }
        .environmentObject(SettingsViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(EditEmailAddressViewModel())
    }
}
