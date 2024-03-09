//
//  BlurBlackBackground.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-07.
//

import SwiftUI

struct BlurBlackBackground: View {
    
    @EnvironmentObject var biometricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    
    var body: some View {
        ZStack {
            BackgroundClearView()
                .background(.black.opacity(0.5))
            
            if(biometricAuthenticationAnimationViewModel.currentAuthenticationType == .faceID) {
                if(biometricAuthenticationAnimationViewModel.showSideButtonAnimation) {
                    VStack {
                        HStack {
                            Spacer()
                            
                            HStack {
                                Text("Double Click\nto Pay")
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.white)
                                    .frame(width: 50, height: 100)
                            }
                            .offset(x: biometricAuthenticationAnimationViewModel.doubleClickToPayRectangleOffset) // 34 to 44
                        }
                        Spacer()
                    }
                    .padding(.top, 128)
                    .onReceive(biometricAuthenticationAnimationViewModel.sideButtonTimer, perform: { _ in
                        biometricAuthenticationAnimationViewModel.playSideButtonAnimation()
                    })
                    .onTapGesture(count: 2) {
                        biometricAuthenticationAnimationViewModel.showConfirmWithSideButton = false
                        withAnimation(.easeInOut) {
                            biometricAuthenticationAnimationViewModel.showSideButtonAnimation = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            biometricAuthenticationAnimationViewModel.startAnimation = true
                        }
                    }
                }
            }
        }
    }
}

struct BlurBlackBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BlurBlackBackground()
                .preferredColorScheme(.dark)
            
            BlurBlackBackground()
        }
        .environmentObject(BiometricAuthenticationAnimationViewModel())
    }
}
