//
//  ContactPickerSheetViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI

class ContactPickerSheetViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = ContactPickerSheetViewModel()
    
    // present a contact picker sheet to select a contact to send an sms
    @Published var isPresentedContactPickerSheet = false
    // present an alert when the selected contact has no number assigned to it
    @Published var isPresentedEmptyContactNoAlert: Bool = false
    // the image layer where secondary color is applied on
    @Published var tellAFriendImageSecondaryColorLayer: String = "InviteAFriendSecondaryColorLayer"
    // the image layer where accent color is applied on
    @Published var tellAFriendImageAccentColorLayer: String = "InviteAFriendAccentColorLayer"
    // the image layer where shadow color is applied on
    @Published var tellAFriendImageShadowLayer: String = "InviteAFriendShadowLayer"
    
    // MARK: INITIALIZERS
    init() {
        
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: sendInvitationMessage
    func sendInvitationMessage(phoneNo: String){
        let message = "Happening Invitation Message Goes Here..."
        let sms: String = "sms:\(phoneNo)&body=\(message)"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
}
