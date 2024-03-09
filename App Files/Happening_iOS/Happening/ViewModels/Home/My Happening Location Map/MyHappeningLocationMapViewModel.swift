//
//  CurrentLocationMapViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-03.
//

import MapKit
import SwiftUI

final class MyHappeningLocationMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = MyHappeningLocationMapViewModel()
    
    // reference to LocationSearchService class
    let locationSearchService = LocationSearchService.shared
    
    // reference to CreateAHappeningViewModel
    let createAHappeningVM = CreateAHappeningViewModel.shared
    
    var locationManager: CLLocationManager?
    
    // region that tells the map where to focus at and zoom
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation,
                                               span: MapDetails.currentLocationSpan)
    
    // happening locationcoordinates will be stored here
    @Published var happeningLocation = [MyHappeningLocation]()
    
    // decide whether the location setter pin is visible or not
    @Published var showLocationSetterPin: Bool = true
    
    // state whether the user is searching on location search text field or not
    @Published var isSearching: Bool = false {
        didSet {
            withAnimation(.spring()) {
                if(isSearching) {
                    whenClickOnTextField()
                } else {
                    whenClickOnCancel()
                }
            }
        }
    }
    
    // controls the offsets of MapOverlaySheet View
    @Published var startingOffsetY: CGFloat = UIScreen.main.bounds.size.height * 0.8
    @Published var currentDragOffsetY: CGFloat = 0
    @Published var endingOffsetY: CGFloat = 0 {
        didSet {
            if(endingOffsetY == 0) {
                whenDismissed()
            }
        }
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: checkIfLocationServiceIsEnabled
    func checkIfLocationServiceIsEnabled() {
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            // present an alert
            print("show an alert letting them knowthis is off and to go and turn it on is Settings.")
        }
    }
    
    // MARK: checkLocationAuthorization
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            // ask user for location permission
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            // present an alert
            print("Your location is restricted likely due to parental controls.")
            
        case .denied:
            // present an alert
            print("You have denied this app location permission. Go into settings to change it.")
            
        case .authorizedAlways, .authorizedWhenInUse:
            // shows current location coordinates
            if(!happeningLocation.isEmpty) {
                region = MKCoordinateRegion(center: happeningLocation[0].coordinate, span: MapDetails.currentLocationSpan)
            } else {
                focusOnCurrentLocation()
            }
            
        @unknown default:
            break
        }
    }
    
    // MARK: focusOnCurrentLocation
    func focusOnCurrentLocation() {
        guard let lm = locationManager else { return }
        
        region = MKCoordinateRegion(center: lm.location?.coordinate ?? MapDetails.startingLocation,
                                    span: MapDetails.currentLocationSpan)
    }
    
    // MARK: locationManagerDidChangeAuthorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    // MARK: searchLocation
    func searchLocation(locationName: String) {
        let searchRequest = MKLocalSearch.Request()
        // provide one location name that was selected from the location list to get coordinates of a placamark
        searchRequest.naturalLanguageQuery = locationName
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            // get coordinates of the  first placamark in the mapItems array
            let item = response.mapItems[0]
            
            withAnimation(.spring()) {
                self.region = MKCoordinateRegion(center: item.placemark.coordinate, span: MapDetails.searchedResultsSpan)
            }
            print("Coordinates of '\(item.name ?? "")': \(item.placemark.coordinate)")
        }
    }
    
    // MARK: setHappeningAnnotation
    func setHappeningAnnotation() {
        
        showLocationSetterPin = false
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: region.center.latitude,
                longitude: region.center.longitude
            ),
            span: region.span)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error -> Void in
            
            guard let placeMark = placemarks?.first else { return }
            
            self.happeningLocation = [
                MyHappeningLocation(
                    latitude: self.region.center.latitude,
                    longitude: self.region.center.longitude,
                    street: placeMark.thoroughfare ?? "",
                    city: placeMark.locality ?? "",
                    district: placeMark.subAdministrativeArea ?? "",
                    province: placeMark.administrativeArea ?? ""
                )
            ]
            
            self.createAHappeningVM.setLocationStatus = .set
            
            let data = self.happeningLocation[0]
            print("Happening Location Coordinates (Latitude: \(data.latitude) Longitude: \(data.longitude))")
            print("Happening LocationAddress: \(data.address)\n\n")
        })
    }
    
    // MARK: removeHappeningAnnotation
    func removeHappeningAnnotation() {
        showLocationSetterPin = true
        happeningLocation.removeAll()
        createAHappeningVM.setLocationStatus = .notSet
    }
    
    // MARK: setMap
    func setMap() {
        let map = MKMapView.appearance()
        map.showsCompass = false
        map.isRotateEnabled = true
        map.mapType = .hybrid
    }
    
    // MARK: whenClickOnTextField
    func whenClickOnTextField() {
        showLocationSetterPin = false
        endingOffsetY = -startingOffsetY
    }
    
    // MARK: whenClickOnCancel
    func whenClickOnCancel() {
        locationSearchService.queryFragment = ""
        hideKeyboard()
        endingOffsetY = 0
    }
    
    // MARK: whenClickOnLocationItem
    func whenClickOnLocationItem() {
        hideKeyboard()
        endingOffsetY = 0
        removeHappeningAnnotation()
    }
    
    
    // MARK: whenDragMap
    func whenDragMap() {
        hideKeyboard()
        endingOffsetY = 0
    }
    
    // MARK: whenOnClick
    func whenDismissed() {
        hideKeyboard()
        if(!happeningLocation.isEmpty) {
            createAHappeningVM.happeningAddressTextFieldText = happeningLocation[0].address
        } else {
            createAHappeningVM.happeningAddressTextFieldText = ""
        }
    }
}
