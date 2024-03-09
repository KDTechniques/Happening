//
//  BiometricAuthenticationAnimationView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-06.
//

import SwiftUI

struct BiometricAuthenticationAnimationView: View {
    
    @Environment(\.dismiss) var presentationMode
    @EnvironmentObject var vm: BiometricAuthenticationAnimationViewModel
    @EnvironmentObject var happeningsVM: HappeningsViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    
    @Binding var isPresentedApplePaySheet: Bool
    
    let item: HappeningItemModel
    
    @State private var count: Int = 0
    
    @State private var isDone: Bool = false {
        didSet {
            count += 1
            if count < 2 {
                if !happeningsVM.reserveASpaceIDRegisterArray.contains(item.id) {
                    happeningsVM.reserveASpaceIDRegisterArray.append(item.id)
                    happeningsVM.payForAHappening(userUID: item.userUID, happeningDocID: item.id) { status in
                        if status {
                            isPresentedApplePaySheet = false
                            ContentViewModel.shared.notificationViewBadgeCount += 1
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                happeningsVM.getCustomHappenings { _ in }
                                notificationManager.scheduleNotification(title: "YOU HAVE A HAPPENING TODAY", subTitle: item.title, ssdt: item.ssdt)
                            }
                        } else {
                            isPresentedApplePaySheet = false
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                happeningsVM.alertItemForHappeningInformationView = AlertItemModel(
                                    title: "Payment Failed",
                                    message: "Something went wrong. Please try again later.",
                                    dismissButton: .cancel(Text("OK")) {
                                        presentationMode.callAsFunction()
                                        
                                        if let index = happeningsVM.reserveASpaceIDRegisterArray.firstIndex(of: item.id) {
                                            happeningsVM.reserveASpaceIDRegisterArray.remove(at: index)
                                        } else {
                                            print("error removing a reserveASpaceIDRegisterArray index.")
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: -2) {
            switch vm.currentAuthenticationType {
            case .touchID:
                ZStack {
                    if(!vm.showCheckMarkCircle) {
                        Image("ezgif.com-gif-maker-\(vm.touchIDAnimationFrameCount) (dragged)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .onReceive(vm.touchIDFrameTimer) { _ in
                                if(vm.startAnimation) {
                                    vm.bioMetricAnimationText = "Processing"
                                    if(vm.touchIDAnimationFrameCount < 28) {
                                        vm.touchIDAnimationFrameCount += 1
                                    }
                                    if(vm.touchIDAnimationFrameCount == 28) {
                                        vm.showCheckMarkCircle = true
                                        vm.paymentProcessingImageOpacity = 1
                                        vm.bioMetricAnimationText = "Processing Payment"
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                            vm.bioMetricAnimationText = "Done"
                                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                                isDone = true
                                                return
                                            }
                                        }
                                    }
                                } else {
                                    vm.bioMetricAnimationText = "Pay with Touch ID"
                                }
                            }
                    } else {
                        ZStack {
                            Image("paymentProcessing")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45)
                                .rotationEffect(.degrees(vm.paymentProcessingImageRotationDegrees))
                                .opacity(vm.paymentProcessingImageOpacity)
                                .onReceive(vm.touchIDFrameTimer) { _ in
                                    vm.paymentProcessingImageRotationDegrees += 35
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                        withAnimation(.spring()) {
                                            vm.paymentProcessingImageOpacity = .zero
                                        }
                                    }
                                }
                            
                            Image("touchIDCheckMarkCircle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45)
                                .opacity(vm.paymentProcessingImageOpacity == 0 ? 1 : 0)
                        }
                    }
                }
                .frame(height: 60)
                
            case .faceID:
                ZStack {
                    if(!vm.showConfirmWithSideButton) {
                        Image("ezgif.com-gif-maker (1)-\(vm.faceIDAnimationFrameCount) (dragged)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .onReceive(vm.faceIDFrameTimer) { _ in
                                vm.bioMetricAnimationText = "Face ID"
                                if(vm.startAnimation) {
                                    vm.bioMetricAnimationText = "Processing"
                                    if(vm.faceIDAnimationFrameCount < 106) {
                                        vm.faceIDAnimationFrameCount += 1
                                    }
                                    if(vm.faceIDAnimationFrameCount > 76) {
                                        vm.bioMetricAnimationText = "Done"
                                        isDone = true
                                        return
                                    }
                                }
                            }
                    } else {
                        Image("confirmWithSideButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45)
                            .padding(.vertical, 2.5)
                            .onReceive(vm.touchIDFrameTimer) { _ in
                                vm.bioMetricAnimationText = "Confirm with side button"
                            }
                    }
                }
            }
            
            Text(vm.bioMetricAnimationText)
        }
    }
}

//struct BiometricAuthenticationAnimationView_Previews: PreviewProvider {
//    static var previews: some View {
//        BiometricAuthenticationAnimationView(isPaymentCompleted: .constant(false))
//            .environmentObject(BiometricAuthenticationAnimationViewModel())
//            .previewLayout(.sizeThatFits)
//    }
//}
