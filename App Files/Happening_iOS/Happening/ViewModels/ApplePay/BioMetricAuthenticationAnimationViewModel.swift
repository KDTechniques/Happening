//
//  BioMetricAuthenticationAnimationViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-06.
//

import Foundation
import SwiftUI

class BiometricAuthenticationAnimationViewModel: ObservableObject {
    
    static let shared = BiometricAuthenticationAnimationViewModel()
    
    let touchIDFrameTimer = Timer.publish(every: 0.06, on: .main, in: .common).autoconnect()
    let faceIDFrameTimer = Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()
    let sideButtonTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var currentAuthenticationType: AuthentiactionType
    @Published var touchIDAnimationFrameCount = 0 {
        didSet {
            if(touchIDAnimationFrameCount == 28) {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    SoundManager.shared.playSound(sound: .paymentSuccess)
                }
            }
        }
    }
    @Published var faceIDAnimationFrameCount = 1 {
        didSet {
            if(faceIDAnimationFrameCount == 70) {
                SoundManager.shared.playSound(sound: .paymentSuccess)
            }
        }
    }
    @Published var startAnimation: Bool = false
    @Published var bioMetricAnimationText: String = "" 
    @Published var paymentProcessingImageOpacity: Double = .zero
    @Published var paymentProcessingImageRotationDegrees: Double = .zero
    @Published var showCheckMarkCircle: Bool = false
    @Published var showConfirmWithSideButton: Bool = true
    @Published var isPresentedPaymentsCardsSheet: Bool = false
    @Published var isPresentedTotalPaymentSheet: Bool = false
    @Published var applePaySheetData: ApplePaySheetModel? = nil
    @Published var doubleClickToPayRectangleOffset: CGFloat = 44
    @Published var showSideButtonAnimation: Bool = true
    enum CardTypes {
        case combank
        case hsbc
    }
    
    init() {
        if(bioMetricIdentifier().contains(AuthentiactionType.faceID.rawValue)) {
            currentAuthenticationType = .faceID
        } else {
            currentAuthenticationType = .faceID//.touchID
        }
    }
    
    func sideButtonAnimation() {
        withAnimation(.easeInOut(duration: 0.15)) {
            doubleClickToPayRectangleOffset = 34
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) { [weak self] in
            withAnimation(.easeInOut(duration: 0.15)) {
                self?.doubleClickToPayRectangleOffset = 44
            }
        }
    }
    
    func playSideButtonAnimation() {
        sideButtonAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) { [weak self] in
            self?.sideButtonAnimation()
        }
    }
    
    func clearApplePaySheet() {
        touchIDAnimationFrameCount = 0
        faceIDAnimationFrameCount = 1
        startAnimation = false
        bioMetricAnimationText = ""
        paymentProcessingImageOpacity = .zero
        paymentProcessingImageRotationDegrees = .zero
        showCheckMarkCircle = false
        showConfirmWithSideButton = true
        doubleClickToPayRectangleOffset = 44
        showSideButtonAnimation = true
    }
}
