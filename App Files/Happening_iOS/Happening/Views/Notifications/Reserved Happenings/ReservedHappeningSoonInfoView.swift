//
//  ReservedHappeningSoonInfoView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-03.
//

import SwiftUI
import MapKit

struct ReservedHappeningSoonInfoView: View {
    
    // MARK: PROPERTIES
    
    @Environment(\.dismiss) var presentationMode
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var notificationVM: NotificationsViewModel
    
    let item: HappeningItemModel
    
    @State private var isPresentedPhoneActionSheet: Bool = false
    @State private var isPresentedMessageSheet: Bool = false
    
    @State private var chatDataArray = [MessageSheetContentModel]()
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(width: 100, height: 4)
                .cornerRadius(.infinity)
                .padding(.top, 10)
            
            HStack {
                ReservedHappeningSoonInfoToolBarLeadingContentView(
                    profilePhotoURL: item.profilePhotoThumbnailURL,
                    userName: item.userName,
                    ratings: item.ratings,
                    userUID: item.userUID
                )
                
                Spacer()
                
                HappeningSoonInfoToolBarTrailingContentView(isPresentedPhoneActionSheet: $isPresentedPhoneActionSheet, isPresentedMessageSheet: $isPresentedMessageSheet, chatDataArray: $chatDataArray, isFollowing: true,  happeningDocID: item.id)
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 10)
            
            Divider()
            
            List {
                // photo view
                HappeningPhotoSliderVew(imagesURLsArray: item.photosURLArray, title: item.title)
                
                // description
                HappeningDescriptionView(description: item.description)
                
                // date & time
                ReservedHappeningDTView(startingDT: item.startingDateTime, endingDT: item.endingDateTime)
                
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
                ReservedHappeningSpaceFeeView(spaceFee: item.spaceFee)
                
                // ride with uber
                Section {
                    RideThereWithUberButtonView(
                        dropoffLocation: CLLocation(latitude: item.latitude, longitude: item.longitude),
                        dropoffNickname: item.title,
                        dropoffAddress: item.address
                    )
                        .frame(maxWidth: .infinity)
                } header: {
                    Text("Book A Taxi If Needed")
                        .font(.footnote)
                } footer: {
                    Text("You will be redirected to the Uber app.")
                        .font(.footnote)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.grouped)
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
        
    }
}
