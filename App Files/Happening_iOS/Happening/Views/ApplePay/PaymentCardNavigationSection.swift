//
//  PaymentCardNavigationSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-07.
//

import SwiftUI

struct PaymentCardNavigationSection: View {
    
    @EnvironmentObject var biometricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    var body: some View {
        Button {
            biometricAuthenticationAnimationViewModel.isPresentedPaymentsCardsSheet = true
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(height: 70)
                .overlay(
                    HStack {
                        if
                            let imageName = biometricAuthenticationAnimationViewModel.applePaySheetData?.cardImage,
                            let name = biometricAuthenticationAnimationViewModel.applePaySheetData?.cardName,
                            let number = biometricAuthenticationAnimationViewModel.applePaySheetData?.cardNumber {
                            
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 26)
                            
                            VStack(alignment: .leading) {
                                Text(name)
                                    .lineLimit(1)
                                
                                HStack(spacing: 3) {
                                    Text("....")
                                        .fontWeight(.black)
                                        .offset(y: -3)
                                    
                                    Text(number)
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundColor(Color(UIColor.systemGray2))
                    }
                        .padding(.horizontal)
                )
        }
        .padding(.horizontal)
        .foregroundColor(.black)
    }
}

struct PaymentCardNavigationSection_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCardNavigationSection()
            .previewLayout(.sizeThatFits)
            .environmentObject(ColorTheme())
            .environmentObject(BiometricAuthenticationAnimationViewModel())
    }
}
