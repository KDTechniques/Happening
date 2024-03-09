//
//  MapDetails.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-04.
//

import Foundation
import MapKit

public enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 7.5172418, longitude: 80.779494) // Sri Lanka
    static let currentLocationSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) // 0.005
    static let searchedResultsSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03) // 0.03
}
