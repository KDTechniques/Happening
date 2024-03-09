//
//  OTPSheetViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-23.
//

import Foundation

class OTPSheetViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = OTPSheetViewModel()
    
    // otp text field text1
    @Published var otpTextField1Text: String = ""
    // otp text field text2
    @Published var otpTextField2Text: String = ""
    // otp text field text3
    @Published var otpTextField3Text: String = ""
    // otp text field text4
    @Published var otpTextField4Text: String = ""
    // otp text field text5
    @Published var otpTextField5Text: String = ""
    // otp text field text6
    @Published var otpTextField6Text: String = ""
    
    // controls otp text field1 caret visibility
    @Published var isVisibleOTPCaret1: Bool = false
    // controls otp text field2 caret visibility
    @Published var isVisibleOTPCaret2: Bool = false
    // controls otp text field3 caret visibility
    @Published var isVisibleOTPCaret3: Bool = false
    // controls otp text field4 caret visibility
    @Published var isVisibleOTPCaret4: Bool = false
    // controls otp text field5 caret visibility
    @Published var isVisibleOTPCaret5: Bool = false
    // controls otp text field6 caret visibility
    @Published var isVisibleOTPCaret6: Bool = false
    
    // controls otp text field1 caret visibility
    @Published var isVisibleOTPCaret1_2: Bool = false
    // controls otp text field2 caret visibility
    @Published var isVisibleOTPCaret2_2: Bool = false
    // controls otp text field3 caret visibility
    @Published var isVisibleOTPCaret3_2: Bool = false
    // controls otp text field4 caret visibility
    @Published var isVisibleOTPCaret4_2: Bool = false
    // controls otp text field5 caret visibility
    @Published var isVisibleOTPCaret5_2: Bool = false
    // controls otp text field6 caret visibility
    @Published var isVisibleOTPCaret6_2: Bool = false
    
    // count to increase its value along with the timer
    @Published var count: Int = .zero
    
    // status whether the the caret is blinking or not
    @Published var isBlinking: Bool = true
    
    //controls the disability of otp done button
    @Published var isDisabledOTPDoneButton: Bool = true
    
    // controls the invalid status of the otp
    @Published var isInvalidOTP: Bool = false {
        didSet {
            if(isInvalidOTP) {
                vibrate(type: .error)
                self.showVerifyingProgressView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isInvalidOTP = false
                    self.otpTextField1Text = ""
                    self.otpTextField2Text = ""
                    self.otpTextField3Text = ""
                    self.otpTextField4Text = ""
                    self.otpTextField5Text = ""
                    self.otpTextField6Text = ""
                }
            }
        }
    }
    
    // show the progreess view when verifying
    @Published var showVerifyingProgressView: Bool = false
    
    // present an alert item for OTPSheetView
    @Published var alertItemForOTPSheetView: AlertItemModel?
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: resetPhoneNoEditView
    func resetOTPTextFields() {
        otpTextField1Text = ""
        otpTextField2Text = ""
        otpTextField3Text = ""
        otpTextField4Text = ""
        otpTextField5Text = ""
        otpTextField6Text = ""
        isDisabledOTPDoneButton = true
        isInvalidOTP = false
        showVerifyingProgressView = false
    }
    
    // MARK: removeLast
    func removeLastFromOTP() {
        if(otpTextField1Text.count > 1) {
            otpTextField1Text.removeLast()
        }
        if(otpTextField2Text.count > 1) {
            otpTextField2Text.removeLast()
        }
        if(otpTextField3Text.count > 1) {
            otpTextField3Text.removeLast()
        }
        if(otpTextField4Text.count > 1) {
            otpTextField4Text.removeLast()
        }
        if(otpTextField5Text.count > 1) {
            otpTextField5Text.removeLast()
        }
        if(otpTextField6Text.count > 1) {
            otpTextField6Text.removeLast()
        }
    }
    
    // MARK: set6DigitsCodeToEachTextField
    func set6DigitsCodeToEachTextField(string: String) {
        let charactersArray: [Character] = stringToCharactersArray(string: string)
        otpTextField1Text = charactersArray[0].description
        otpTextField2Text = charactersArray[1].description
        otpTextField3Text = charactersArray[2].description
        otpTextField4Text = charactersArray[3].description
        otpTextField5Text = charactersArray[4].description
        otpTextField6Text = charactersArray[5].description
    }
    
    // MARK: validateOTPFields
    func validateOTPFields() -> Bool{
        if(!otpTextField1Text.isEmpty && !otpTextField2Text.isEmpty && !otpTextField3Text.isEmpty && !otpTextField4Text.isEmpty && !otpTextField5Text.isEmpty && !otpTextField6Text.isEmpty) {
            isDisabledOTPDoneButton = false
            return true
        } else {
            isDisabledOTPDoneButton = true
            return false
        }
    }
}
