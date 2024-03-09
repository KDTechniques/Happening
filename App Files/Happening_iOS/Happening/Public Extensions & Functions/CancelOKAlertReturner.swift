//
//  CancelOKAlertReturner.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-23.
//

import Foundation
import SwiftUI

// MARK: title and message
public func cancelOKAlertReturner(title: String, message: String?) -> Alert{
    let title: String = title
    let message: String = message ?? ""
    
    return Alert(title: Text(title), message: Text(message), dismissButton: .cancel(Text("OK")))
}

// MARK: title only
public func cancelOKAlertReturner(title: String) -> Alert{
    let title: String = title
    
    return Alert(title: Text(title), dismissButton: .cancel(Text("OK")))
}
