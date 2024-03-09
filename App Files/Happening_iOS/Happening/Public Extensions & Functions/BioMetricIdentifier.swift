//
//  BioMetricIdentifier.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-26.
//

import Foundation
import UIKit

enum BioMetricType: String {
    case touchID = "Touch ID"
    case faceID = "Face ID"
}

func bioMetricIdentifier() -> String {
    let deviceModel: String = UIDevice.modelName
    switch deviceModel {
    case "iPhone 6s":
        return BioMetricType.touchID.rawValue
    case "iPhone 6s Plus":
        return BioMetricType.touchID.rawValue
    case "iPhone SE":
        return BioMetricType.touchID.rawValue
    case "iPhone 7":
        return BioMetricType.touchID.rawValue
    case "iPhone 7 Plus":
        return BioMetricType.touchID.rawValue
    case "iPhone 8":
        return BioMetricType.touchID.rawValue
    case "iPhone 8 Plus":
        return BioMetricType.touchID.rawValue
    case "iPhone X":
        return BioMetricType.faceID.rawValue
    case "iPhone XS":
        return BioMetricType.faceID.rawValue
    case "iPhone XS Max":
        return BioMetricType.faceID.rawValue
    case "iPhone XR":
        return BioMetricType.faceID.rawValue
    case "iPhone 11":
        return BioMetricType.faceID.rawValue
    case "iPhone 11 Pro":
        return BioMetricType.faceID.rawValue
    case "iPhone 11 Pro Max":
        return BioMetricType.faceID.rawValue
    case "iPhone SE (2nd generation)":
        return BioMetricType.faceID.rawValue
    case "iPhone 12 mini":
        return BioMetricType.faceID.rawValue
    case "iPhone 12":
        return BioMetricType.faceID.rawValue
    case "iPhone 12 Pro":
        return BioMetricType.faceID.rawValue
    case "iPhone 12 Pro Max":
        return BioMetricType.faceID.rawValue
    case "iPhone 13":
        return BioMetricType.faceID.rawValue
    case "iPhone 13 Pro":
        return BioMetricType.faceID.rawValue
    case "iPhone 13 Pro Max":
        return BioMetricType.faceID.rawValue
    default:
        return BioMetricType.faceID.rawValue
    }
}
