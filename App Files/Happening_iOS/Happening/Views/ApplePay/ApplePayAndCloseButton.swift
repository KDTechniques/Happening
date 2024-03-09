//
//  ApplePayAndCloseButton.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-07.
//

import SwiftUI

struct ApplePayAndCloseButton: View {
    
    @EnvironmentObject var biometricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    @Binding var isPresentedApplePaySheet: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "applelogo")
                .font(.title2)
            
            Text("Pay")
                .font(.title.weight(.medium))
            
            Spacer()
            
            Button {
                isPresentedApplePaySheet = false
            } label: {
                Circle().fill(Color(red: 222/255, green: 222/255, blue: 222/255))
                    .frame(width:30, height: 30)
                    .clipShape(Circle())
                    .overlay(
                        Image(systemName: "xmark")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.gray)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

//struct ApplePayAndCloseButton_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ApplePayAndCloseButton()
//            ApplePayAndCloseButton().preferredColorScheme(.dark)
//        }
//            .environmentObject(BiometricAuthenticationAnimationViewModel())
//            .previewLayout(.sizeThatFits)
//    }
//}
