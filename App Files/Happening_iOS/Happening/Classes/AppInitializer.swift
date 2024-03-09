//
//  AppInitializer.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-19.
//

import Foundation
import SwiftUI

class AppInitializer: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = AppInitializer()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: firstTimeOnApp
    /// this function excecutes when user logs in
    func firstTimeOnApp() {
        
        print("'firstTimeOnApp()' Function Has Been Called. 👍🏻👍🏻👍🏻")
        
        // let user direct to home tab in the very first place
        UserDefaults.standard.set(3, forKey: ContentViewModel.shared.selectedTabKeyName)
        
        // add default about list items to user defaults
        EditAboutViewModel.shared.addDefaultAboutListItems()
        
        appInitializer()
    }
    
    
    // MARK: appInitializer
    func appInitializer() {
        print( print("'appInitializer()' Function Has Been Called. 👍🏻👍🏻👍🏻"))
        
        ContentViewModel.shared.notificationViewBadgeCount = UserDefaults.standard.integer(forKey: ContentViewModel.shared.badgeCountUserDefaultsKeyName)
        
        ProfileBasicInfoViewModel.shared.getBasicProfileDataFromFirestore { status in
            if status {
                HappeningsViewModel.shared.isPresentedProgressView = true
                HappeningsViewModel.shared.getCustomHappenings {
                    if !$0 {
                        HappeningsViewModel.shared.isPresentedErrorText = true
                    } else {
                        if !HappeningsViewModel.shared.happeningsDataArray.isEmpty {
                            HappeningsViewModel.shared.isPresentedErrorText = false
                        }
                    }
                }
            } else {
                print("Something Went Wrong. Unable To Retrieve Profile Data. ☹️☹️☹️")
            }
        }
        
        ReservedHViewModel.shared.getReservedHappeningItems { _ in }
        
        MemoriesViewModel.shared.connectedTimer1 = MemoriesViewModel.shared.memoryProgressBartimer1.upstream.connect()
        MemoriesViewModel.shared.connectedTimer2 = MemoriesViewModel.shared.memoryProgressBartimer2.upstream.connect()
        MemoriesViewModel.shared.connectedTimer3 = MemoriesViewModel.shared.memoriesUploadStateCheckingTimer.upstream.connect()
        
        MemoriesViewModel.shared.getMyMemoriesDataFromUserDefaults()
        
        MemoriesViewModel.shared.getMyMemoriesDataFromFirestoreNStoreInUserDefaults() { _ in }
        
        MemoriesViewModel.shared.getMyFollowingsMemoriesDataFromUserDefaults()
        
        MemoriesViewModel.shared.getFollowingsMemoriesDataFromFirestore()
        
        MessageSheetViewModel.shared.getIsTypingChatDataFromFirestore { _ in }
        
        MyHappeningsViewModel.shared.participantsProfileDataArray = MyHappeningsViewModel.shared.getParticipantsProfileDataArrayFromUserDefaults()
    }
}
