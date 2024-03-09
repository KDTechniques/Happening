//
//  NotificationsViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-02.
//

import Foundation
import Firebase

class NotificationsViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = NotificationsViewModel()
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // reference to CurrentUser
    let currentUser = CurrentUser.shared
    
    // reference to MessageSheetViewModel
    let messageSheetVM = MessageSheetViewModel.shared
    
    // controls the current notification type
    @Published var notificationTypeSelection: NotificationTypes = .messagses // change this to reserved happenings later
    
    // set of types of the notifications
    enum NotificationTypes: String, CaseIterable {
        case reservedHappenings = "Reserved H"
        case messagses = "Messages"
        case participatedHappening = "Participated H"
    }
    
    // controls the picker state of a participator and a creator
    @Published var participatorOrCreatorSelection: MessagesAsATypes = .participator
    
    // messages as a type of either participator or creator when checking message notifications
    enum MessagesAsATypes  {
        case participator
        case creator
    }
}
