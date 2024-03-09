//
//  HappeningInformationView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-29.
//

import SwiftUI
import MapKit

struct HappeningInformationView: View {
    
    // MARK: PROPERTIES
    
    @Environment(\.dismiss) var presentationMode
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var bioMetricAuthenticationAnimationViewModel: BiometricAuthenticationAnimationViewModel
    @EnvironmentObject var happeningVM: HappeningsViewModel
    
    let item: HappeningItemModel
    
    @State private var isPresentedPhoneActionSheet: Bool = false
    @State private var isPresentedApplePaySheet: Bool = false
    @State private var isPresentedMessageSheet: Bool = false
    
    @State private var chatDataArray = [MessageSheetContentModel]()
    
    // MARK: BODY
    var body: some View {
        List {
            // photo view
            HappeningPhotoSliderVew(imagesURLsArray: item.photosURLArray, title: item.title)
            
            // description
            HappeningDescriptionView(description: item.description)
            
            // date & time
            HappeningDTView(startingDT: item.startingDateTime, endingDT: item.endingDateTime)
            
            // address or the secure address
            HappeningAddressView(address: item.followingStatus ? item.address : item.secureAddress)
            
            // location
            HappeningLocationMapView(
                region: MKCoordinateRegion(
                    center:
                        CLLocationCoordinate2D(
                            latitude: item.latitude,
                            longitude: item.longitude
                        ),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ),
                happeningLocation: [
                    HappeningLocation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: item.latitude,
                            longitude: item.longitude
                        )
                    )
                ],
                latitude: item.latitude,
                longitude: item.longitude,
                photoURL: item.thumbnailPhotoURL,
                title: item.title,
                isFollowing: item.followingStatus
            )
            
            // space fee
            HappeningSpaceFeeView(
                spaceFee: item.spaceFee,
                isFollowing: item.followingStatus,
                userName: item.userName
            )
            
            // reserve a space
            HappeningReserveASpaceView(isFollowing: item.followingStatus, spaceFee: item.spaceFee, userUID: item.userUID, happeningDocumentID: item.id, isPresentedApplePaySheet: $isPresentedApplePaySheet)
        }
        .listStyle(.grouped)
        .fullScreenCover(isPresented: $isPresentedApplePaySheet,  onDismiss: {
            bioMetricAuthenticationAnimationViewModel.clearApplePaySheet()
        }) {
            ApplePaySheetContentView(item: item, isPresentedApplePaySheet: $isPresentedApplePaySheet)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HappeningInfoToolBarLeadingContentView(
                    profilePhotoURL: item.profilePhotoThumbnailURL,
                    userName: item.userName,
                    isFollowing: item.followingStatus,
                    ratings: item.ratings,
                    userUID: item.userUID
                )
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HappeningInfoToolBarTrailingContentView(
                    isPresentedPhoneActionSheet: $isPresentedPhoneActionSheet,
                    isPresentedMessageSheet: $isPresentedMessageSheet,
                    chatDataArray: $chatDataArray,
                    isFollowing: item.followingStatus,
                    happeningDocID: item.id)
            }
        }
        .actionSheet(isPresented: $isPresentedPhoneActionSheet) {
            ActionSheet(
                title: Text("Call \(item.userName)?"),
                message: Text("Carrier charges may apply. Calls will place through your mobile carrier, not over the internet."),
                buttons: [
                    .default(Text("OK")) {
                        // code
                        callNumber(phoneNo: item.phoneNo)
                    },
                    .cancel()
                ]
            )
        }
        .alert(item: $happeningVM.alertItemForHappeningInformationView, content: { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: alert.dismissButton)
        })
        .sheet(isPresented: $isPresentedMessageSheet) {
            MessageSheetContentView(
                chatDataArrayItem: $chatDataArray,
                profilePhotoThumURL: item.profilePhotoThumbnailURL,
                happeningDocID: item.id,
                happeningTitle: item.title,
                receiverUID: item.userUID,
                receiverName: item.userName
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}
