//
//  ParticipatedHViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-10.
//

import Foundation
import Firebase

class ParticipatedHViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = ParticipatedHViewModel()
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // reference to CurrentUser
    let currentUser = CurrentUser.shared
    
    // controls the searching text of the participated happening notifications
    @Published var searchTextParticipatedH: String = "" {
        didSet {
            // filterResults(participatedHText: searchTextParticipatedH)
        }
    }
    
    // state whether the user is searching something on participated happening notifications
    @Published var isSearchingParticipatedH: Bool = false
    
    // MARK: FUNCTIONS
    
}
