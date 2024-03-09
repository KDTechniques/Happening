//
//  EditAboutViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class EditAboutViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = EditAboutViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to user defaults
    let defaults = UserDefaults.standard
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // AboutListArrayItems user defaults key that contains array of data related about list
    let aboutListArrayItemsUserDefaultsKeyName: String = "AboutListArrayItems"
    
    // controls the sheet related to editing custom about text
    @Published var isPresentedAboutSheet: Bool = false
    
    // about text field text
    @Published var aboutTextFieldText:String = ""
    
    // controls disability of the save button of the about editting sheet
    @Published var isDisabledAboutSaveButton: Bool = false
    
    // controls progress view of the about editing list
    @Published var showProgressViewInEditAboutView: Bool = false
    
    // an array of about list items where it takes values only from user defaults about list
    @Published var aboutItemListArray = [String]()
    
    // present an alert item for EditAboutView
    @Published var alertItemForEditAboutView: AlertItemModel?
    
    // MARK: FUNCTIONS
    
    
    
    //MARK: addDefaultAboutListItems
    func addDefaultAboutListItems() {
        
        // this array consist of all the default about items data
        let defaultAboutListItemsArray = [
            "Available",
            "Busy",
            "At school",
            "At the gym",
            "At the movies",
            "At work",
            "Battery about to die",
            "Can't talk, Happening only",
            "Sleeping",
            "Urgent calls only",
            "Hey there! I am using Happening"
        ]
        
        // save the default about list array in user defaults
        defaults.set(defaultAboutListItemsArray, forKey: aboutListArrayItemsUserDefaultsKeyName)
        
        print("Default About List Items Have Been Added To User Defaults. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
    }
    
    // MARK: deleteAboutListItem
    func deleteAboutListItem(indexSet: IndexSet) {
        
        // first get the about list array from user defaults
        var array = defaults.stringArray(forKey: aboutListArrayItemsUserDefaultsKeyName)
        
        // get the index that need to be reomoved and remove from the created array above
        array?.remove(atOffsets: indexSet)
        
        // once the required index item is removed, save the created array back to user defaults
        defaults.set(array, forKey: aboutListArrayItemsUserDefaultsKeyName)
        
        aboutItemListArray.removeAll() // for safety reasons
        
        aboutItemListArray = defaults.stringArray(forKey: aboutListArrayItemsUserDefaultsKeyName) ?? []
    }
    
    // MARK: moveAboutListItem
    func moveAboutListItem(from: IndexSet, to: Int) {
        
        // first get the about list array from user defaults
        var array = defaults.stringArray(forKey: aboutListArrayItemsUserDefaultsKeyName)
        
        // get the index that need to be moved from the created array above
        array?.move(fromOffsets: from, toOffset: to)
        
        // once the required index item is removed, save the created array back to user defaults
        defaults.set(array, forKey: aboutListArrayItemsUserDefaultsKeyName)
        
        aboutItemListArray.removeAll() // for safety reasons
        
        aboutItemListArray = defaults.stringArray(forKey: aboutListArrayItemsUserDefaultsKeyName) ?? []
    }
    
    // MARK: updateAboutToFirestore
    func updateAboutToFirestore(about: String?) {
        
        // check whether the current user uid is avilable or not
        guard
            let docID = currentUser.currentUserUID,
            let about =  about else { return }
        
        // save the selected about item to the firestore
        db
            .collection("Users/\(docID)/ProfileData")
            .document(docID)
            .updateData(["About":about]) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    // check whether the about list saved in the user defaults is empty or not
                    guard var array = self.defaults.stringArray(forKey: self.aboutListArrayItemsUserDefaultsKeyName) else { return }
                    
                    // a count variable that helps to identify whether there's a matching about item in the list that's same as the new about item we created.
                    var count: Int = 0
                    
                    // for loop that map each and every about itm in the list to find out whether there's a match with th one we created
                    for index in array.indices {
                        if(array[index] == about) {
                            // if there's a match in the list, the count will be increased in one
                            count +=  1
                        }
                    }
                    
                    // if the count is 0 means there's no matches with the about list
                    if(count == 0) {
                        
                        // if there's no match with the list we can go ahead and append the newly created about itm to the array we created
                        array.append(about)
                        
                        //  save the appended aray back to user defaults
                        self.defaults.set(array, forKey: self.aboutListArrayItemsUserDefaultsKeyName)
                        
                        self.aboutItemListArray.removeAll() // for safety reasons
                        
                        self.aboutItemListArray = self.defaults.stringArray(forKey: self.aboutListArrayItemsUserDefaultsKeyName) ?? []
                        
                        // save the current about item also to the user defaults
                        self.defaults.set(about, forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.about.rawValue)
                        self.showProgressViewInEditAboutView = false
                    } else {
                        // if the count is greater than 1 means, there's match with the created about item in the list
                        // so save it in the current about item in user defaults
                        
                        self.defaults.set(about, forKey: ProfileBasicInfoViewModel.ProfileBasicInfoUserDefaultsType.about.rawValue)
                        self.showProgressViewInEditAboutView = false
                    }
                    
                    print("About Item Has Been Updated Successfully. 👍🏻👍🏻👍🏻")
                }
            }
    }
}
