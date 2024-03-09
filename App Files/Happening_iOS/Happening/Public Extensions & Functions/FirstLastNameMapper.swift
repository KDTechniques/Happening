//
//  FirstLastNameMapper.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-04.
//

import Foundation

public func getFirstName(fullName: String) -> String {
    var firstName = ""
    var lastName = ""
    var components = fullName.components(separatedBy: " ")
    if (components.count > 0) {
        firstName = components.removeFirst()
        lastName = components.joined(separator: " ")
    }
    return firstName
}

public func getLastName(fullName: String) -> String {
    var firstName = ""
    var lastName = ""
    var components = fullName.components(separatedBy: " ")
    if (components.count > 0) {
        firstName = components.removeFirst()
        lastName = components.joined(separator: " ")
    }
    return lastName
}
