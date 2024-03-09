//
//  MyHappeningLocationMapView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-06-01.
//

import SwiftUI
import MapKit

struct MyHappeningLocationView: View {
    
    // MARK: PROPERTIES
    
    @State var region: MKCoordinateRegion
    @State var happeningLocation: [HappeningLocation]
    
    let latitude: Double
    let longitude: Double
    
    let photoURL: String
    let title: String
    
    // MARK: BODY
    var body: some View {
        Section {
            VStack(spacing: 0) {
                Map(coordinateRegion: $region, annotationItems: happeningLocation) {
                    MapAnnotation(coordinate: $0.coordinate) {
                        CustomAnnotationPin(
                            photoURL: photoURL,
                            notationText: title,
                            isDynamicNotationTextColor: true
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                
                Divider()
                
                Button("See on Google Maps") {
                    openWithGoogleMaps()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .listRowInsets(EdgeInsets())
        } header: {
            Text("Location")
                .font(.footnote)
        }
    }
    
    func openWithGoogleMaps() {
        let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
        
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            openWithBrowser()
        }
    }
    
    func openWithBrowser() {
        let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
        UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
    }
}
