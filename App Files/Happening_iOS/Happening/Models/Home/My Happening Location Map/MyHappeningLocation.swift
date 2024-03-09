//
//  MyHappeningLocation.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-04.
//

import MapKit

struct MyHappeningLocation: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let street: String
    let city: String
    let district: String
    let province: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var address: String  {
        
        var s: String = ""
        var c: String = ""
        var d: String = ""
        var p: String = ""
        
        if(street != "") { s = "\(street), " }
        if(city != "") { c = "\(city), " }
        if(district != "") { d = "\(district), " }
        if(province != "") { p = "\(province)." }
        
        return "\(s)\(c)\(d)\(p)"
    }
    
    var secureAddress: String {
        
        var c: String = ""
        var d: String = ""
        var p: String = ""
        
        if(city != "") { c = "\(city), " }
        if(district != "") { d = "\(district), " }
        if(province != "") { p = "\(province)" }
        
        return "\(c)\(d)\(p)"
    }
}
