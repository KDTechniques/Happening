//
//  AddressModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-31.
//

import Foundation
import SwiftUI

struct AddressModel {
    
    init(data: [String:Any]) {
        
        let address = data["Address"] as? [String: String]
        street1 = address?["Street1"] ?? "..."
        street2 = address?["Street2"] ?? "..."
        city = address?["City"] ?? "..."
        postCode = address?["Postcode"] ?? "..."
    }
    
    var street1: String
    var street2: String
    var city: String
    var postCode: String
}
