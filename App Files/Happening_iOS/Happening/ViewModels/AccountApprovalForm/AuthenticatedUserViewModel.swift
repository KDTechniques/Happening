//
//  AuthenticatedUserViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-24.
//

import Foundation
import SwiftUI

class AuthenticatedUserViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    static let shared = AuthenticatedUserViewModel()
    
    @Published var userData: AuthenticatedUserModel? = nil
}
