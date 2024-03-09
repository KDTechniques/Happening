//
//  ApplePayButtonView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-07.
//

import SwiftUI

struct ApplePayButtonView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var bioMetricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    @Binding var isPresentedApplePaySheet: Bool
    
    var body: some View {
        Button {
            bioMetricAuthenticationAnimationViewModel.applePaySheetData = ApplePaySheetModel(cardType: .combank)
            isPresentedApplePaySheet = true
        } label: {
            HStack {
                Text("Pay with")
                HStack(spacing: 0) {
                    Image(systemName: "applelogo")
                        .font(.system(size: 16))
                        .offset(y: -0.6)
                    Text("Pay")
                }
            }
            .font(.system(size: 20).weight(.medium))
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background((colorScheme == .dark ? .white : .black))
            .cornerRadius(6)
        }
    }
}

//struct ApplePayButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ApplePayButtonView()
//            ApplePayButtonView().preferredColorScheme(.dark)
//        }
//        .environmentObject(BiometricAuthenticationAnimationViewModel())
//        .environmentObject(ColorTheme())
//    }
//}
