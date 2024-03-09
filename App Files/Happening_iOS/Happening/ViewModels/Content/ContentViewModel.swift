//
//  ContentViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-27.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    static let shared = ContentViewModel()
    
    // controls the Tab View seletion
    @Published var selectedTab: Int = 3
    
    //controls the rendering mode of the status icon
    @Published var statusIconRenderingMode: Image.TemplateRenderingMode = .original
    
    // decides status icon name in the assets according to rendering mode
    @Published var statusIconName: StatusIconName = .Active
    
    // selected tab key name in the user defaults
    let selectedTabKeyName: String = "selectedTab"
    
    // status icon rendering mode types
    enum StatusIconName: String {
        case Normal = "StatusIcon"
        case Active = "StatusIconActive"
    }
    
    // controls the key name of the notification view badge count value stored in user defaults
    let badgeCountUserDefaultsKeyName: String = "notificationBadgeCount"
    
    // controls the number of notifications badge on notification tab
    @Published var notificationViewBadgeCount: Int = 0 {
        didSet {
            UserDefaults.standard.set(notificationViewBadgeCount, forKey: badgeCountUserDefaultsKeyName)
        }
    }
    
    // MARK: FUNCTIONS
    
    //MARK: saveSelectedTabToUserDefaults
    func saveSelectedTabToUserDefaults() {
        UserDefaults.standard.set(selectedTab, forKey: selectedTabKeyName)
    }
    
    // MARK: getSelectedTabFromUserDefaults
    func getSelectedTabFromUserDefaults() {
        selectedTab = UserDefaults.standard.integer(forKey: selectedTabKeyName)
    }
}
