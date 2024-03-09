//
//  MyHappeningInformationView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI
import MapKit

struct MyHappeningInformationView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var myHappeningsVM: MyHappeningsViewModel
    
    let item: MyHappeningModel
    
    let phoneNumber: String? = UserDefaults.standard.string(forKey: EditProfileViewModel.EditProfileViewUserDefaultsType.phoneNo.rawValue)
    
    @State private var participatorsProfileDataArray = [ParticipantBasicProfileDataModel]()
    
    // MARK: BODY
    var body: some View {
        List {
            // Photo Slider
            MyHappeningPhotoSliderView(imagesURLsArray: item.photosURLArray, title: item.title)
            
            // Description
            MyHappeningDescriptionView(description: item.description)
            
            // Date & Time
            MyHappeningDTView(startingDT: item.startingDateTime, endingDT: item.endingDateTime)
            
            // Address
            MyHappeningAddressView(address: item.address)
            
            // Location
            MyHappeningLocationView(
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
                title: item.title
            )
            
            // Space Fee
            MyHappeningSpaceFeeView(spaceFee: item.spaceFee)
            
            // Phone No
            if let phoneNumber = phoneNumber {
                MyHappeningPhoneNoView(phoneNo: phoneNumber)
            }
            
            // Participants
            if !participatorsProfileDataArray.isEmpty {
                MyHappeningParticipantsView(participantsProfileDataArray: participatorsProfileDataArray, numberOfSpaces: item.noOfSpaces)
            }
            
            // Ride With Uber
            RideWithUberView(
                latitude: item.latitude,
                longitude: item.longitude,
                title: item.title,
                address: item.address
            )
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            participatorsProfileDataArray.removeAll()
            for id in item.participatorsUIDArray {
                if let object = myHappeningsVM.participantsProfileDataArray.first(where: { $0.userUID == id }) {
                    participatorsProfileDataArray.append(object)
                }
            }
        }
    }
}
