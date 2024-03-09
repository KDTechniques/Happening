//
//  GetCurrentDateAndTime.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-08.
//

import Foundation

let dateFormatter = DateFormatter()

public func getCurrentDateAndTime(format: String) -> String{
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.string(from: Date.now)
}
