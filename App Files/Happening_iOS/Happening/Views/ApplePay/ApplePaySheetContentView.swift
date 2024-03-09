//
//  ApplePaySheetContentView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-06.
//

import SwiftUI

struct ApplePaySheetContentView: View {
    
    @EnvironmentObject var biometricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    let item: HappeningItemModel
    
    @Binding var isPresentedApplePaySheet: Bool
    
    var body: some View {
        ZStack {
            BlurBlackBackground()
            
            VStack {
                Spacer()
                
                VStack {
                    VStack {
                        ApplePayAndCloseButton(isPresentedApplePaySheet: $isPresentedApplePaySheet)
                        
                        PaymentCardNavigationSection()
                            .sheet(isPresented: $biometricAuthenticationAnimationViewModel.isPresentedPaymentsCardsSheet) {
                                PaymentCardsSection()
                            }
                        
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(.white)
                                .frame(height:70)
                                .overlay(
                                    TotalPaymentNavigationSection(fee: item.spaceFee)
                                        .sheet(isPresented: $biometricAuthenticationAnimationViewModel.isPresentedTotalPaymentSheet, content: {
                                            TotalPaymentSheetView(fee: item.spaceFee, activity: item.title)
                                        })
                                )
                            
                            Rectangle()
                                .fill(Color(red: 222/255, green: 222/255, blue: 222/255))
                                .frame(height: 1.5)
                            
                            AuthenticationAnimationViewSection(isPresentedApplePaySheet: $isPresentedApplePaySheet, item: item)
                        }
                    }
                }
                .foregroundColor(.black)
                .background(Color(red: 234/255, green: 234/255, blue: 234/255))
                .cornerRadius(10)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

//struct ApplePaySheetContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ApplePaySheetContentView(fee: "LKR1000", activity: "Assembling a Gaming PC 💻", isPaymentCompleted: .constant(false))
//                .preferredColorScheme(.dark)
//            
//            ApplePaySheetContentView(fee: "LKR1000", activity: "Assembling a Gaming PC 💻", isPaymentCompleted: .constant(false))
//        }
//        .environmentObject(BiometricAuthenticationAnimationViewModel())
//        .environmentObject(ColorTheme())
//    }
//}
