//
//  LaunchScreenView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-11.
//

import SwiftUI

struct LaunchScreenView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var faceID: FaceIDAuthentication
    
    // controls the frame size, opacity and horizontal offset of the logo icon
    @State private var frame1: CGFloat = .zero
    @State private var opacity1: CGFloat = 1
    @State private var offset1: CGFloat = .zero
    
    // controls the opacity of the characters in thr logo animation
    // all of the characters are invisible in thr first place.
    @State private var opacityCharacter1: CGFloat = .zero
    @State private var opacityCharacter2: CGFloat = .zero
    @State private var opacityCharacter3: CGFloat = .zero
    @State private var opacityCharacter4: CGFloat = .zero
    @State private var opacityCharacter5: CGFloat = .zero
    @State private var opacityCharacter6: CGFloat = .zero
    @State private var opacityCharacter7: CGFloat = .zero
    @State private var opacityCharacter8: CGFloat = .zero
    @State private var opacityCharacter9: CGFloat = .zero
    
    // controls the animation screen
    @State private var showAnimation: Bool = true
    // to prevent authentication while animating
    @State private var accurateCondition: Bool = false
    
    // MARK: BODY
    @ViewBuilder
    var body: some View {
        ZStack {
            if(showAnimation) {
                LogoLabelView(frame1: $frame1, opacity1: $opacity1, offset1: $offset1)
                HappeningCharactersView(opacityCharacter1: $opacityCharacter1, opacityCharacter2: $opacityCharacter2, opacityCharacter3: $opacityCharacter3, opacityCharacter4: $opacityCharacter4, opacityCharacter5: $opacityCharacter5, opacityCharacter6: $opacityCharacter6, opacityCharacter7: $opacityCharacter7, opacityCharacter8: $opacityCharacter8, opacityCharacter9: $opacityCharacter9)
                
            } else if(faceID.isReauthenticationEnabled) {
                AppLockedScreenView()
            } else if(faceID.isUnlocked) {
                ViewNavigator()
            } else {
                Text("")
                    .alert(isPresented: $faceID.isNoBiometricAlertPresented) {
                        Alert(
                            title: Text("\(bioMetricIdentifier()) Has Been Disabled"),
                            message: Text("Allow access to \(bioMetricIdentifier()) on Settings."),
                            primaryButton: .default(Text("Open Settings"), action: { goToAppSettings() }),
                            secondaryButton: .default(Text("Use Passcode"), action: { faceID.passCodeAuthentication() })
                        )
                    }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.1)) {
                frame1 = 50.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    offset1 = -100.50
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                opacity1 = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.31) {
                opacityCharacter1 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                opacityCharacter2 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                opacityCharacter3 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
                opacityCharacter4 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                opacityCharacter5 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                opacityCharacter6 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.37) {
                opacityCharacter7 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
                opacityCharacter8 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.39) {
                opacityCharacter9 = 1.0
                // accurateCondition: authentication process begins once the animation is completed.
                accurateCondition = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
                if(accurateCondition) {
                    showAnimation = false
                    if(faceID.isFaceIDAuthenticationEnabled) {
                        faceID.authenticate()
                    } else {
                        faceID.isUnlocked = true
                    }
                }
            }
        }
    }
}

// MARK: PREVIEWS
struct LoadingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LaunchScreenView().preferredColorScheme(.dark)
            LaunchScreenView()
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(ColorTheme())
        .environmentObject(FaceIDAuthentication())
        .environmentObject(SignInViewModel())
    }
}
