//
//  CalculateAgeFromBirthDate.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-15.
//

import Foundation

public func calculateAge(birthDate: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM yyyy"
    let date = dateFormatter.date(from: birthDate)
    
    guard let date = date else { return "..." }
    
    return String(Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0)
}
