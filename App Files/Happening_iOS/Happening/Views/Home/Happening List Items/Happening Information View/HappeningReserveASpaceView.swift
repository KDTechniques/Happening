//
//  HappeningReserveASpaceView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import SwiftUI

struct HappeningReserveASpaceView: View {
    
    // MARK: PROPERTIES
    
    @Environment(\.dismiss) var presentationMode
    @EnvironmentObject var happeningsVM: HappeningsViewModel
    @EnvironmentObject var contentVM: ContentViewModel
    
    let isFollowing: Bool
    let spaceFee: String
    let userUID: String
    let happeningDocumentID: String
    
    @Binding var isPresentedApplePaySheet: Bool
    
    // MARK: BODY
    var body: some View {
        if isFollowing {
            if !spaceFee.contains("Free") {
                Section {
                    ApplePayButtonView(isPresentedApplePaySheet: $isPresentedApplePaySheet)
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                } header: {
                    Text("Reserve a Space")
                        .font(.footnote)
                } footer: {
                    Text("You will receive a notification after reserving a space.")
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } else {
                Section {
                    Button("Reserve a Space") {
                        happeningsVM.reserveASpaceIDRegisterArray.append(happeningDocumentID)
                        happeningsVM.payForAHappening(userUID: userUID, happeningDocID: happeningDocumentID) { status in
                            if status {
                                contentVM.notificationViewBadgeCount += 1
                                happeningsVM.alertItemForHappeningInformationView = AlertItemModel(
                                    title: "Reservation Success",
                                    message: "You will receive a confirmation notification now.",
                                    dismissButton: .default(Text("OK")) {
                                        happeningsVM.getCustomHappenings { _ in }
                                    }
                                )
                            } else {
                                happeningsVM.alertItemForHappeningInformationView = AlertItemModel(
                                    title: "Unable To Reserve A Space",
                                    message: "Something went wrong. Please try again later.",
                                    dismissButton: .default(Text("OK")) {
                                        presentationMode.callAsFunction()
                                        
                                        if let index = happeningsVM.reserveASpaceIDRegisterArray.firstIndex(of: happeningDocumentID) {
                                            happeningsVM.reserveASpaceIDRegisterArray.remove(at: index)
                                        } else {
                                            print("error removing a reserveASpaceIDRegisterArray index.")
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(happeningsVM.reserveASpaceIDRegisterArray.contains(happeningDocumentID) ? true : false)
                } footer: {
                    Text("You will receive a notification after reserving a space.")
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

// MARK: PREVIEWS
//struct HappeningReserveASpaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        HappeningReserveASpaceView()
//    }
//}
