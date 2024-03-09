//
//  RideThereWithUberButtonView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-05.
//

import SwiftUI
import UberRides
import CoreLocation

struct RideThereWithUberButtonViewUIViewRepresentable: UIViewRepresentable {
    
    @Environment(\.colorScheme) var colorScheme
    @State var button = RideRequestButton()
    
    let dropoffLocation: CLLocation
    let dropoffNickname: String
    let dropoffAddress: String
    
    func makeUIView(context: Context) -> some UIView {
        let dropoffLocation = dropoffLocation
        let builder = RideParametersBuilder()
        builder.dropoffLocation = dropoffLocation
        builder.dropoffNickname = dropoffNickname
        builder.dropoffAddress = dropoffAddress
        
        button.colorStyle = colorScheme == .dark ? .white : .black
        button.rideParameters = builder.build()
        return button
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        button.colorStyle = colorScheme == .dark ? .white : .black
    }
}

struct RideThereWithUberButtonView: View {
    
    let dropoffLocation: CLLocation
    let dropoffNickname: String
    let dropoffAddress: String
    
    var body: some View {
        RideThereWithUberButtonViewUIViewRepresentable(dropoffLocation: dropoffLocation, dropoffNickname: dropoffNickname, dropoffAddress: dropoffAddress)
            .frame(width: 240, height: 25+(14*2))
            .frame(width: 180)
            .offset(x: 17)
            .clipped()
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: UIScreen.main.bounds.size.width - 40, height: 25+(14*2))
            )
    }
}

struct RideThereWithUberButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RideThereWithUberButtonView(dropoffLocation: CLLocation(latitude: 0, longitude: 0), dropoffNickname: "", dropoffAddress: "")
                .preferredColorScheme(.dark)
            
            RideThereWithUberButtonView(dropoffLocation: CLLocation(latitude: 0, longitude: 0), dropoffNickname: "", dropoffAddress: "")
        }
        .environmentObject(ColorTheme())
    }
}
