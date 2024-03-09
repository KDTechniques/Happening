//
//  AuthenticationAnimationViewSection.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-07.
//

import SwiftUI

struct AuthenticationAnimationViewSection: View {
    
    @EnvironmentObject var biometricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    @Binding var isPresentedApplePaySheet: Bool
    
    let item: HappeningItemModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
            
            VStack {
                BiometricAuthenticationAnimationView(isPresentedApplePaySheet: $isPresentedApplePaySheet, item: item)
                    .padding(.top, bioMetricIdentifier()
                                .contains(AuthentiactionType.faceID.rawValue) ? 6 : 1)
                
                Spacer()
            }
            .onTapGesture {
                if(biometricAuthenticationAnimationViewModel.currentAuthenticationType == .touchID) {
                    biometricAuthenticationAnimationViewModel.startAnimation = true
                }
            }
            
        }
        .frame(height: bioMetricIdentifier()
                .contains(AuthentiactionType.faceID.rawValue) ? 100 : 90)
    }
}

//struct AuthenticationAnimationViewSection_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthenticationAnimationViewSection(isPaymentCompleted: .constant(false))
//            .environmentObject(BiometricAuthenticationAnimationViewModel())
//            .previewLayout(.sizeThatFits)
//    }
//}
