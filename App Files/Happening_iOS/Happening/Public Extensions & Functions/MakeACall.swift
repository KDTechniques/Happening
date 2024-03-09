//
//  MakeACall.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-19.
//

import Foundation
import SwiftUI

public func callNumber(phoneNo: String){
    if let url = URL(string: "tel://\(phoneNo)"), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
