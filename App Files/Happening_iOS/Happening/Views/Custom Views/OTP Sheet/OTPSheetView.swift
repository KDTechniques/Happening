//
//  OTPSheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-02.
//

import SwiftUI

struct OTPSheetView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var phoneNoAuthManager: PhoneNoAuthManager
    @EnvironmentObject var otpSheetViewModel: OTPSheetViewModel
    @EnvironmentObject var networkManager: NetworkManger
    
    // focusable fields related to OTP
    @FocusState var fieldInFocus: SixDigitsOTPTextfieldTypes?
    
    // controls verification sent to text
    @Binding var verificationSentTo: String
    
    // decide whether the verification type is email or phone no
    @Binding var verificationType: VerificationTypes
    
    // decide whether the otp sheet need to be presented or not
    @Binding var isPresentedOTPSheet: Bool
    
    // state whether the otp code is valid or not
    @Binding var isVerfied: VerificationStatus
    
    // timer to control the blinking speed of the otp text field caret
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    // MARK: BODY
    var body: some View {
        VStack {
            Text("Enter Verification PIN")
                .fontWeight(.semibold)
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            Text("Please enter the verification PIN we sent to\n\(verificationSentTo)")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            HStack(spacing: 0) {
                // 1st otp text field
                OTPTextFieldView(textFieldText: $otpSheetViewModel.otpTextField1Text, isVisibleCaret1: $otpSheetViewModel.isVisibleOTPCaret1, isVisibleCaret2: $otpSheetViewModel.isVisibleOTPCaret1_2, isBlinking: $otpSheetViewModel.isBlinking)
                    .focused($fieldInFocus, equals: .firstDigit)
                    .onChange(of: otpSheetViewModel.otpTextField1Text) { _ in
                        if(otpSheetViewModel.otpTextField1Text.count == 6) {
                            otpSheetViewModel.set6DigitsCodeToEachTextField(string: otpSheetViewModel.otpTextField1Text)
                        } else {
                            otpSheetViewModel.removeLastFromOTP()
                            let status = otpSheetViewModel.validateOTPFields()
                            if(otpSheetViewModel.otpTextField1Text.count > 0) {
                                if(status){
                                    fieldInFocus = .none
                                } else {
                                    self.fieldInFocus = .secondDigit
                                }
                            }
                            if(fieldInFocus == .firstDigit && otpSheetViewModel.otpTextField1Text.isEmpty) {
                                otpSheetViewModel.isVisibleOTPCaret1_2 = false
                                otpSheetViewModel.isVisibleOTPCaret1 = true
                            }
                        }
                    }
                    .onChange(of: fieldInFocus) { newValue in
                        if(newValue == .firstDigit && otpSheetViewModel.otpTextField1Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret1 = true
                        } else {
                            otpSheetViewModel.isVisibleOTPCaret1 = false
                        }
                        if(newValue == .firstDigit && !otpSheetViewModel.otpTextField1Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret1_2 = true
                        }
                        if(newValue != .firstDigit) {
                            otpSheetViewModel.isVisibleOTPCaret1_2 = false
                        }
                    }
                
                // 2nd otp text field
                OTPTextFieldView(textFieldText: $otpSheetViewModel.otpTextField2Text, isVisibleCaret1: $otpSheetViewModel.isVisibleOTPCaret2, isVisibleCaret2: $otpSheetViewModel.isVisibleOTPCaret2_2, isBlinking: $otpSheetViewModel.isBlinking)
                    .focused($fieldInFocus, equals: .secondDigit)
                    .onChange(of: otpSheetViewModel.otpTextField2Text) { _ in
                        if(otpSheetViewModel.otpTextField2Text.count == 6) {
                            otpSheetViewModel.set6DigitsCodeToEachTextField(string: otpSheetViewModel.otpTextField2Text)
                        } else {
                            otpSheetViewModel.removeLastFromOTP()
                            let status = otpSheetViewModel.validateOTPFields()
                            if(otpSheetViewModel.otpTextField2Text.count > 0) {
                                if(status){
                                    fieldInFocus = .none
                                } else {
                                    self.fieldInFocus = .thirdDigit
                                }
                            } else {
                                self.fieldInFocus = .firstDigit
                            }
                            if(fieldInFocus == .secondDigit && otpSheetViewModel.otpTextField2Text.isEmpty) {
                                otpSheetViewModel.isVisibleOTPCaret2_2 = false
                                otpSheetViewModel.isVisibleOTPCaret2 = true
                            }
                        }
                    }
                    .onChange(of: fieldInFocus) { newValue in
                        if(newValue == .secondDigit && otpSheetViewModel.otpTextField2Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret2 = true
                        } else {
                            otpSheetViewModel.isVisibleOTPCaret2 = false
                        }
                        if(newValue == .secondDigit && !otpSheetViewModel.otpTextField2Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret2_2 = true
                        }
                        if(newValue != .secondDigit) {
                            otpSheetViewModel.isVisibleOTPCaret2_2 = false
                        }
                    }
                
                // 3rd otp text field
                OTPTextFieldView(textFieldText: $otpSheetViewModel.otpTextField3Text, isVisibleCaret1: $otpSheetViewModel.isVisibleOTPCaret3, isVisibleCaret2: $otpSheetViewModel.isVisibleOTPCaret3_2, isBlinking: $otpSheetViewModel.isBlinking)
                    .focused($fieldInFocus, equals: .thirdDigit)
                    .onChange(of: otpSheetViewModel.otpTextField3Text) { _ in
                        if(otpSheetViewModel.otpTextField3Text.count == 6) {
                            otpSheetViewModel.set6DigitsCodeToEachTextField(string: otpSheetViewModel.otpTextField3Text)
                        } else {
                            otpSheetViewModel.removeLastFromOTP()
                            let status = otpSheetViewModel.validateOTPFields()
                            if(otpSheetViewModel.otpTextField3Text.count > 0) {
                                if(status){
                                    fieldInFocus = .none
                                } else {
                                    self.fieldInFocus = .fourthDigit
                                }
                            } else {
                                self.fieldInFocus = .secondDigit
                            }
                            if(fieldInFocus == .thirdDigit && otpSheetViewModel.otpTextField3Text.isEmpty) {
                                otpSheetViewModel.isVisibleOTPCaret3_2 = false
                                otpSheetViewModel.isVisibleOTPCaret3 = true
                            }
                        }
                    }
                    .onChange(of: fieldInFocus) { newValue in
                        if(newValue == .thirdDigit && otpSheetViewModel.otpTextField3Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret3 = true
                        } else {
                            otpSheetViewModel.isVisibleOTPCaret3 = false
                        }
                        if(newValue == .thirdDigit && !otpSheetViewModel.otpTextField3Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret3_2 = true
                        }
                        if(newValue != .thirdDigit) {
                            otpSheetViewModel.isVisibleOTPCaret3_2 = false
                        }
                    }
                
                // 4th otp text field
                OTPTextFieldView(textFieldText: $otpSheetViewModel.otpTextField4Text, isVisibleCaret1: $otpSheetViewModel.isVisibleOTPCaret4, isVisibleCaret2: $otpSheetViewModel.isVisibleOTPCaret4_2, isBlinking: $otpSheetViewModel.isBlinking)
                    .focused($fieldInFocus, equals: .fourthDigit)
                    .onChange(of: otpSheetViewModel.otpTextField4Text) { _ in
                        if(otpSheetViewModel.otpTextField4Text.count == 6) {
                            otpSheetViewModel.set6DigitsCodeToEachTextField(string: otpSheetViewModel.otpTextField4Text)
                        } else {
                            otpSheetViewModel.removeLastFromOTP()
                            let status = otpSheetViewModel.validateOTPFields()
                            if(otpSheetViewModel.otpTextField4Text.count > 0) {
                                if(status){
                                    fieldInFocus = .none
                                } else {
                                    self.fieldInFocus = .fifthDigit
                                }
                            } else {
                                self.fieldInFocus = .thirdDigit
                            }
                            if(fieldInFocus == .fourthDigit && otpSheetViewModel.otpTextField4Text.isEmpty) {
                                otpSheetViewModel.isVisibleOTPCaret4_2 = false
                                otpSheetViewModel.isVisibleOTPCaret4 = true
                            }
                        }
                    }
                    .onChange(of: fieldInFocus) { newValue in
                        if(newValue == .fourthDigit && otpSheetViewModel.otpTextField4Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret4 = true
                        } else {
                            otpSheetViewModel.isVisibleOTPCaret4 = false
                        }
                        if(newValue == .fourthDigit && !otpSheetViewModel.otpTextField4Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret4_2 = true
                        }
                        if(newValue != .fourthDigit) {
                            otpSheetViewModel.isVisibleOTPCaret4_2 = false
                        }
                    }
                
                // 5th otp text field
                OTPTextFieldView(textFieldText: $otpSheetViewModel.otpTextField5Text, isVisibleCaret1: $otpSheetViewModel.isVisibleOTPCaret5, isVisibleCaret2: $otpSheetViewModel.isVisibleOTPCaret5_2, isBlinking: $otpSheetViewModel.isBlinking)
                    .focused($fieldInFocus, equals: .fifthDigit)
                    .onChange(of: otpSheetViewModel.otpTextField5Text) { _ in
                        if(otpSheetViewModel.otpTextField5Text.count == 6) {
                            otpSheetViewModel.set6DigitsCodeToEachTextField(string: otpSheetViewModel.otpTextField5Text)
                        } else {
                            otpSheetViewModel.removeLastFromOTP()
                            let status = otpSheetViewModel.validateOTPFields()
                            if(otpSheetViewModel.otpTextField5Text.count > 0) {
                                if(status){
                                    fieldInFocus = .none
                                } else {
                                    self.fieldInFocus = .sixthDigit
                                }
                            } else {
                                self.fieldInFocus = .fourthDigit
                            }
                            if(fieldInFocus == .fifthDigit && otpSheetViewModel.otpTextField5Text.isEmpty) {
                                otpSheetViewModel.isVisibleOTPCaret5_2 = false
                                otpSheetViewModel.isVisibleOTPCaret5 = true
                            }
                        }
                    }
                    .onChange(of: fieldInFocus) { newValue in
                        if(newValue == .fifthDigit && otpSheetViewModel.otpTextField5Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret5 = true
                        } else {
                            otpSheetViewModel.isVisibleOTPCaret5 = false
                        }
                        if(newValue == .fifthDigit && !otpSheetViewModel.otpTextField5Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret5_2 = true
                        }
                        if(newValue != .fifthDigit) {
                            otpSheetViewModel.isVisibleOTPCaret5_2 = false
                        }
                    }
                
                //  6th otp text field
                OTPTextFieldView(textFieldText: $otpSheetViewModel.otpTextField6Text, isVisibleCaret1: $otpSheetViewModel.isVisibleOTPCaret6, isVisibleCaret2: $otpSheetViewModel.isVisibleOTPCaret6_2, isBlinking: $otpSheetViewModel.isBlinking)
                    .focused($fieldInFocus, equals: .sixthDigit)
                    .onChange(of: otpSheetViewModel.otpTextField6Text) { _ in
                        if(otpSheetViewModel.otpTextField6Text.count == 6) {
                            otpSheetViewModel.set6DigitsCodeToEachTextField(string: otpSheetViewModel.otpTextField6Text)
                        } else {
                            otpSheetViewModel.removeLastFromOTP()
                            let status = otpSheetViewModel.validateOTPFields()
                            if(otpSheetViewModel.otpTextField6Text.count > 0) {
                                if(status){
                                    fieldInFocus = .none
                                } else {
                                    self.fieldInFocus = .none
                                }
                            } else {
                                self.fieldInFocus = .fifthDigit
                            }
                            if(fieldInFocus == .sixthDigit && otpSheetViewModel.otpTextField6Text.isEmpty) {
                                otpSheetViewModel.isVisibleOTPCaret6_2 = false
                                otpSheetViewModel.isVisibleOTPCaret6 = true
                            }
                        }
                    }
                    .onChange(of: fieldInFocus) { newValue in
                        if(newValue == .sixthDigit && otpSheetViewModel.otpTextField6Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret6 = true
                        } else {
                            otpSheetViewModel.isVisibleOTPCaret6 = false
                        }
                        if(newValue == .sixthDigit && !otpSheetViewModel.otpTextField6Text.isEmpty) {
                            otpSheetViewModel.isVisibleOTPCaret6_2 = true
                        }
                        if(newValue != .sixthDigit) {
                            otpSheetViewModel.isVisibleOTPCaret6_2 = false
                        }
                    }
            }
            .padding()
            .padding(.top, 10)
            
            Text("Invalid Code")
                .foregroundColor(.red)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.top, 1)
                .opacity(otpSheetViewModel.isInvalidOTP ? 1 : 0)
            
            ButtonView(name: "Done") {
                switch verificationType {
                case .phoneNo:
                    hideKeyboard()
                    if(networkManager.connectionStatus == .connected) {
                        otpSheetViewModel.showVerifyingProgressView = true
                        // verify the code with the firebase
                        let verificationCode = otpSheetViewModel.otpTextField1Text+otpSheetViewModel.otpTextField2Text+otpSheetViewModel.otpTextField3Text+otpSheetViewModel.otpTextField4Text+otpSheetViewModel.otpTextField5Text+otpSheetViewModel.otpTextField6Text
                        
                        print("Entered Code: \(verificationCode)")
                        
                        phoneNoAuthManager.verifyCode(code: verificationCode) { Returnedstatus in
                            if(Returnedstatus == .success) {
                                print("Phone Number Verification Susccess. 👍🏻👍🏻👍🏻")
                                isPresentedOTPSheet = false
                                isVerfied = .verified
                            } else {
                                print("Code Is Invalid. 🥲🥲🥲")
                                otpSheetViewModel.isInvalidOTP = true
                            }
                        }
                    } else {
                        otpSheetViewModel.alertItemForOTPSheetView = AlertItemModel(
                            title: "Couldn't Verify Phone Number",
                            message: "Check your phone's connection and try again."
                        )
                    }
                    
                case .email:
                    if(networkManager.connectionStatus == .connected) {
                        print("Email Verification Type")
                    } else {
                        otpSheetViewModel.alertItemForOTPSheetView = AlertItemModel(
                            title: "Couldn't Verify Email Address",
                            message: "Check your phone's connection and try again."
                        )
                    }
                }
            }
            .opacity(otpSheetViewModel.isDisabledOTPDoneButton ? 0.5 : 1)
            .disabled(otpSheetViewModel.isDisabledOTPDoneButton)
            
            if(otpSheetViewModel.showVerifyingProgressView) {
                ProgressView("Verifying...")
                    .tint(.secondary)
                    .padding(.top, 50)
            }
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.7) {
                fieldInFocus = .firstDigit
            }
        }
        .onReceive(timer) { _ in
            otpSheetViewModel.count += 1
            if(otpSheetViewModel.count % 2 != 0) {
                otpSheetViewModel.isBlinking = false
            } else {
                otpSheetViewModel.isBlinking = true
            }
        }
        .alert(item: $otpSheetViewModel.alertItemForOTPSheetView) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message))
        }
    }
}

// MARK: PREVIEWS
struct OTPSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                OTPSheetView(verificationSentTo: Binding.constant("0770050165"), verificationType: Binding.constant(.phoneNo), isPresentedOTPSheet: Binding.constant(true), isVerfied: Binding.constant(.verify))
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                OTPSheetView(verificationSentTo: Binding.constant("kdtechniques@gmail.com"), verificationType: Binding.constant(.email), isPresentedOTPSheet: Binding.constant(true), isVerfied: Binding.constant(.verify))
            }
        }
        .environmentObject(ColorTheme())
        .environmentObject(PhoneNoAuthManager())
        .environmentObject(OTPSheetViewModel())
        .environmentObject(NetworkManger())
    }
}
