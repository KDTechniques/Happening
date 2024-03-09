//
//  RideWithUberView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI
import MapKit

struct RideWithUberView: View {
    
    // MARK: PROPERTIES
    let latitude: Double
    let longitude: Double
    let title: String
    let address: String
    
    // MARK: BODY
    var body: some View {
        Section {
            RideThereWithUberButtonView(
                dropoffLocation: CLLocation(latitude: latitude, longitude: longitude),
                dropoffNickname: title,
                dropoffAddress: address
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
}

// MARK: PREVIEWS
struct RideWithUberView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                RideWithUberView(
                    latitude: 12.13413213,
                    longitude: 44.21341314,
                    title: "Shopping @ One Galle Face M. 🏢",
                    address: "No.23, Vijaya Rd, 3rd Kurana, Negombo."
                )
            }
            .preferredColorScheme(.dark)
            
            List {
                RideWithUberView(
                    latitude: 12.13413213,
                    longitude: 44.21341314,
                    title: "Shopping @ One Galle Face M. 🏢",
                    address: "No.23, Vijaya Rd, 3rd Kurana, Negombo."
                )
            }
        }
        .listStyle(.grouped)
    }
}
