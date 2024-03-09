//
//  HappeningLocation.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-30.
//

import Foundation
import MapKit

struct HappeningLocation: Identifiable {
    
    let id = UUID().uuidString
    let coordinate: CLLocationCoordinate2D
}
