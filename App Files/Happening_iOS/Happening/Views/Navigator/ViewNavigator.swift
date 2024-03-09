//
//  ViewNavigator.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-13.
//

import SwiftUI

struct ViewNavigator: View {
    
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        if(currentUser.isUserSignedOut && !currentUser.isExistingUser && !currentUser.isApprovedUser && currentUser.currentUserUID == nil) {
            SignInView()
        } else  if(!currentUser.isUserSignedOut && !currentUser.isExistingUser && !currentUser.isApprovedUser && currentUser.currentUserUID != nil) {
            AccountApprovalSubmissionFormView()
        } else if(!currentUser.isUserSignedOut && currentUser.isExistingUser && !currentUser.isApprovedUser && currentUser.currentUserUID != nil) {
            PendingAccountApprovalView()
        } else if(!currentUser.isUserSignedOut && currentUser.isExistingUser && currentUser.isApprovedUser && currentUser.currentUserUID != nil) {
            ContentView()
        } else {
            SignInView()
        }
    }
}

struct ViewNavigator_Previews: PreviewProvider {
    static var previews: some View {
        ViewNavigator()
            .environmentObject(CurrentUser())
    }
}
