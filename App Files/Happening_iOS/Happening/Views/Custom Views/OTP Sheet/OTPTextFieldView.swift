//
//  OTPTextFieldView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-02.
//

import SwiftUI

struct OTPTextFieldView: View {
    
    // MARK: PROPERTIES
    
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var otpSheetViewModel: OTPSheetViewModel
    
    @Binding var textFieldText: String
    @Binding var isVisibleCaret1: Bool
    @Binding var isVisibleCaret2: Bool
    @Binding var isBlinking: Bool
    
    // MARK: BODY
    
    var body: some View {
        TextField("", text: $textFieldText)
            .keyboardType(.asciiCapableNumberPad)
            .foregroundColor(.clear)
            .accentColor(.clear)
            .background(Color(UIColor.systemBackground))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(otpSheetViewModel.isInvalidOTP ? .red : (isVisibleCaret1 || isVisibleCaret2) ? color.accentColor : Color(UIColor.systemGray2), lineWidth: 2)
                    .frame(width: 45, height: 45)
                
                Text(textFieldText)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                if(isVisibleCaret1 && otpSheetViewModel.isBlinking) {
                    Text("l")
                        .font(.title)
                        .foregroundColor(color.accentColor)
                        .opacity(isVisibleCaret1 ? 1 : 0)
                }
                if(isVisibleCaret2 && otpSheetViewModel.isBlinking) {
                    Text("l")
                        .font(.title)
                        .foregroundColor(color.accentColor)
                        .opacity(isVisibleCaret2 ? 1 : 0)
                        .padding(.leading)
                }
            }
    }
}

// MARK: PREVIEWS
struct OTPTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OTPTextFieldView(textFieldText: Binding.constant("7"), isVisibleCaret1: Binding.constant(true), isVisibleCaret2: Binding.constant(false), isBlinking: Binding.constant(true))
                .preferredColorScheme(.dark)
            
            OTPTextFieldView(textFieldText: Binding.constant("7"), isVisibleCaret1: Binding.constant(true), isVisibleCaret2: Binding.constant(true), isBlinking: Binding.constant(true))
        }
        .environmentObject(ColorTheme())
        .environmentObject(OTPSheetViewModel())
    }
}
