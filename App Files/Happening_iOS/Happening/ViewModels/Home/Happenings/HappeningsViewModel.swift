//
//  HappeningsViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-26.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

class HappeningsViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = HappeningsViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // controls the searching text of the happenings list
    @Published var searchText: String = "" {
        didSet {
            filterResults(text: searchText)
        }
    }
    
    // to prevent calling didSet function two times in a row because, isSearching will set to false two times in a row when user unfocuses the searching text field.
    var count: Int = 0
    // state whether the user is searchiong a happening or not
    @Published var isSearching: Bool = false
    
    // controls the state of retreiving followings happenings
    @Published var followingsOnlyStatus: followingsOnlyStatusTypes = .on {
        didSet {
            searchText.removeAll()
            happeningsDataArray.removeAll()
            isPresentedProgressView = true
            getCustomHappenings {
                if !$0 {
                    self.isPresentedErrorText = true
                } else {
                    if !self.happeningsDataArray.isEmpty {
                        self.isPresentedErrorText = false
                    }
                }
            }
        }
    }
    
    // state types whether to receive followings happening or not
    enum followingsOnlyStatusTypes {
        case on
        case off
    }
    
    // alert item for Home View
    @Published var alertItemForHomeView: AlertItemModel?
    
    // store all the happenings data from followings or not followings
    @Published var happeningsDataArray = [HappeningItemModel]() {
        didSet {
            filteredHappeningsDataArray = happeningsDataArray
        }
    }
    
    // store all the filtered happenings data from followings or not followings
    @Published var filteredHappeningsDataArray = [HappeningItemModel]()
    
    // controls variables of the HappeningFilterOptionsView
    
    // controls the minimum space value for a happening
    @Published var minSpaceFeeTextFieldText: String = "" {
        didSet {
            if !minSpaceFeeTextFieldText.isEmpty || !maxSpaceFeeTextFieldText.isEmpty {
                isSelectedPaidButton = true
            }
        }
    }
    
    // controls the maximum space value for a happening
    @Published var maxSpaceFeeTextFieldText: String = "" {
        didSet {
            if !minSpaceFeeTextFieldText.isEmpty || !maxSpaceFeeTextFieldText.isEmpty {
                isSelectedPaidButton = true
            }
        }
    }
    
    // // controls the city or provice keyword for a happening
    @Published var cityOrProvinceTextFieldText: String = "" {
        didSet {
            if !cityOrProvinceTextFieldText.isEmpty {
                isSelectedNearMeButton = false
            }
        }
    }
    
    // present the filter options sheet for happenings
    @Published var isPresentedFilterOptionsSheet: Bool = false
    
    // controls all the buttons of the filter options sheet
    
    // state whether the happening sooner button is selected or not
    @Published var isSelectedHappeningSoonerButton: Bool = false {
        didSet {
            if isSelectedHappeningSoonerButton {
                isSelectedHappeningLaterButton = false
            }
        }
    }
    
    // state whether the happening later button is selected or not
    @Published var isSelectedHappeningLaterButton: Bool = false {
        didSet {
            if isSelectedHappeningLaterButton {
                isSelectedHappeningSoonerButton = false
            }
        }
    }
    
    // state whether the free button is selected or not
    @Published var isSelectedFreeButton: Bool = false {
        didSet {
            if isSelectedFreeButton {
                isSelectedPaidButton = false
                minSpaceFeeTextFieldText.removeAll()
                maxSpaceFeeTextFieldText.removeAll()
            }
        }
    }
    
    // state whether the paid button is selected or not
    @Published var isSelectedPaidButton: Bool = false {
        didSet {
            if isSelectedPaidButton {
                isSelectedFreeButton = false
            } else {
                minSpaceFeeTextFieldText.removeAll()
                maxSpaceFeeTextFieldText.removeAll()
            }
        }
    }
    
    // state whether the near  me button is selected or not
    @Published var isSelectedNearMeButton: Bool = false {
        didSet {
            if isSelectedNearMeButton {
                cityOrProvinceTextFieldText.removeAll()
            }
        }
    }
    
    // state whether the 5 stars button is selected or not
    @Published var isSelected5StarsButton: Bool = false {
        didSet {
            if isSelected5StarsButton {
                
                isSelected4StarsNupButton = false
                isSelected3StarsNupButton = false
                isSelected2StarsNupButton = false
                isSelected1StarNupButton = false
            }
        }
    }
    
    // state whether the 4 stars & up button is selected or not
    @Published var isSelected4StarsNupButton: Bool = false {
        didSet {
            if isSelected4StarsNupButton {
                
                isSelected5StarsButton = false
                isSelected3StarsNupButton = false
                isSelected2StarsNupButton = false
                isSelected1StarNupButton = false
            }
        }
    }
    
    // state whether the 3 stars & up button is selected or not
    @Published var isSelected3StarsNupButton: Bool = false {
        didSet {
            if isSelected3StarsNupButton {
                
                isSelected5StarsButton = false
                isSelected4StarsNupButton = false
                isSelected2StarsNupButton = false
                isSelected1StarNupButton = false
            }
        }
    }
    
    // state whether the 2 stars & up button is selected or not
    @Published var isSelected2StarsNupButton: Bool = false {
        didSet {
            if isSelected2StarsNupButton {
                
                isSelected5StarsButton = false
                isSelected4StarsNupButton = false
                isSelected3StarsNupButton = false
                isSelected1StarNupButton = false
            }
        }
    }
    
    // state whether the 1 star & up button is selected or not
    @Published var isSelected1StarNupButton: Bool = false {
        didSet {
            if isSelected1StarNupButton {
                
                isSelected5StarsButton = false
                isSelected4StarsNupButton = false
                isSelected3StarsNupButton = false
                isSelected2StarsNupButton = false
            }
        }
    }
    
    // present a progress view while fetching happening data from firestore
    @Published var isPresentedProgressView: Bool = false
    
    // present an error text if something goes wrong in the happening list data while fetching from firestore
    @Published var isPresentedErrorText: Bool = false
    
    // present an alert item for HappeningFilterOptionsView
    @Published var alertItemForHappeningFilterOptionsView: AlertItemModel?
    
    // present an alert item for HappeningInformationView
    @Published var alertItemForHappeningInformationView: AlertItemModel?
    
    // an array that stores reserved happenings at the time of clicking on a button
    @Published var reserveASpaceIDRegisterArray = [String]()
    
    // MARK: FUNCTIONS
    
    // MARK: resetFilterOptionsSheet
    func resetFilterOptionsSheet() {
        
        // sort
        isSelectedHappeningSoonerButton = false
        isSelectedHappeningLaterButton = false
        
        //space fee
        isSelectedFreeButton = false
        isSelectedPaidButton = false
        
        // space fee range
        minSpaceFeeTextFieldText.removeAll()
        maxSpaceFeeTextFieldText.removeAll()
        
        // city/province
        cityOrProvinceTextFieldText.removeAll()
        isSelectedNearMeButton =  false
        
        // rating
        isSelected5StarsButton = false
        isSelected4StarsNupButton = false
        isSelected3StarsNupButton = false
        isSelected2StarsNupButton = false
        isSelected1StarNupButton = false
        
        searchText.removeAll()
        
        getCustomHappenings {
            if !$0 {
                self.isPresentedErrorText =  true
            } else {
                if !self.happeningsDataArray.isEmpty {
                    self.isPresentedErrorText = false
                }
            }
        }
    }
    
    // MARK: getAllUsersIDArray
    private func getAllUsersIDArray(completion: @escaping (_ idArray: [String]?) -> ()) {
        
        var idArray = [String]()
        
        db
            .collection("Users")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot else {
                        print("query snapshot nil.")
                        self.isPresentedProgressView = false
                        self.isPresentedErrorText = true
                        completion(nil)
                        return
                    }
                    
                    if querySnapshot.isEmpty {
                        print("query snapshot has no documents.")
                        self.isPresentedProgressView = false
                        self.isPresentedErrorText = true
                        completion(nil)
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        
                        idArray.append(document.documentID)
                    }
                    
                    completion(idArray)
                    print("All Users IDs Have Been Retrieved Successfully. 👍🏻👍🏻👍🏻")
                }
            }
    }
    
    // MARK: getAllMyFollowings
    private func getAllMyFollowings(completion: @escaping (_ idArray: [String]?) -> ()) {
        
        guard let myUID = currentUser.currentUserUID else {
            print("my uid is nil.")
            completion(nil)
            return
        }
        
        var followingsArray = [String]()
        
        db
            .collection("Users/\(myUID)/FollowingsData")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.documents.isEmpty else {
                        print("query snapshot nil or has no documents.")
                        self.isPresentedProgressView = false
                        self.isPresentedErrorText = true
                        completion(nil)
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        followingsArray.append(document.documentID)
                    }
                    
                    print("IDs Of All The Followings Have Been Retrieved Successfully. 👍🏻👍🏻👍🏻")
                    completion(followingsArray)
                }
            }
    }
    
    // MARK: getUserIDsWithoutFollowingsNMe
    private func getUserIDsWithoutFollowingsNMe(completion: @escaping (_ idArray: [String]?) -> ()) {
        
        guard let myUID = currentUser.currentUserUID else {
            print("my uid nil.")
            completion(nil)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        var followingsIDNMeArray = [String]()
        var allUsersIDArray = [String]()
        
        var allUsersWithoutFollowingsNMeIDArray = [String]()
        
        
        dispatchGroup.enter()
        getAllMyFollowings { idArray in
            
            guard let idArray = idArray, !idArray.isEmpty else {
                completion(nil)
                return
            }
            
            followingsIDNMeArray = idArray
            followingsIDNMeArray.append(myUID)
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.getAllUsersIDArray { idArray in
            
            guard let idArray = idArray, !idArray.isEmpty else {
                completion(nil)
                return
            }
            
            allUsersIDArray = idArray
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            
            for userID in allUsersIDArray {
                
                if !followingsIDNMeArray.contains(userID) {
                    allUsersWithoutFollowingsNMeIDArray.append(userID)
                }
            }
            
            print("All Users ID Without Followings N Me Have Been Created Successfully. 🖤🖤🖤")
            completion(allUsersWithoutFollowingsNMeIDArray)
        }
    }
    
    // MARK: getfollowingsNMeIDArray
    private func getMyUnblockedfollowingsIDArray(completion: @escaping (_ idArray: [String]?) -> ()) {
        
        var idArray = [String]()
        
        guard let myUID = currentUser.currentUserUID else {
            completion(nil)
            return
        }
        
        db
            .collection("Users/\(myUID)/FollowingsData")
            .whereField("isBlocked", isEqualTo: false)
            .getDocuments { querySnapshot, error in
                if let error =  error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot else {
                        print("query snapshot nil.")
                        self.isPresentedProgressView = false
                        self.isPresentedErrorText = true
                        completion(nil)
                        return
                    }
                    
                    if querySnapshot.isEmpty {
                        print("query snapshot has no documents.")
                        self.isPresentedProgressView = false
                        self.isPresentedErrorText = true
                        completion(nil)
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        
                        idArray.append(document.documentID)
                    }
                    
                    print("Created An ID Array Of Followings N Me Successfully. 👍🏻👍🏻👍🏻")
                    completion(idArray)
                }
            }
    }
    
    // MARK: getProfileDataOfAnyUser
    private func getProfileDataOfAnyUser(userUID: String, completion: @escaping (_ profileDataSet: [String:Any]?) -> ()) {
        
        var dataSet = [String:Any]()
        
        db
            .collection("Users/\(userUID)/ProfileData")
            .document(userUID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                } else {
                    
                    guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                        print("document snapshot nil or no documents found.")
                        completion(nil)
                        return
                    }
                    
                    guard let data = documentSnapshot.data() else {
                        print("error getting data from the document snapshot.")
                        completion(nil)
                        return
                    }
                    
                    dataSet = data
                    
                    print("Profile Data Has Been Retreived Successfully. 👍🏻👍🏻👍🏻")
                    completion(dataSet)
                }
            }
    }
    
    // MARK: getCustomHappenings
    func getCustomHappenings(completion: @escaping (_ status: Bool) -> ()) {
        
        switch followingsOnlyStatus {
            
            // only from my following users
        case .on:
            
            searchText.removeAll()
            happeningsDataArray.removeAll()
            
            var tempArray = [HappeningItemModel]()
            
            self.getMyUnblockedfollowingsIDArray { idArray in
                guard let idArray = idArray, !idArray.isEmpty else {
                    completion(false)
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                
                for followingID in idArray {
                    
                    dispatchGroup.enter()
                    
                    self.filterOptionsNavigatorForFollowingsOnly(userUID: followingID, isFollowing: true) { filteredHappeningsArray in
                        
                        if let filteredHappeningsArray = filteredHappeningsArray {
                            
                            for arrayItem in filteredHappeningsArray {
                                tempArray.append(arrayItem)
                            }
                        }
                        
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.happeningsDataArray = self.sortHappenings(array: tempArray)
                    print("Followings Only Happenings Array Has Been Created Successfully. 🖤🖤🖤")
                    self.isPresentedProgressView = false
                    completion(true)
                }
            }
            
        case .off:
            
            searchText.removeAll()
            happeningsDataArray.removeAll()
            
            var tempArray = [HappeningItemModel]()
            
            getUserIDsWithoutFollowingsNMe { idArray in
                guard let idArray = idArray, !idArray.isEmpty else {
                    print("users id without followings n me array nil.")
                    self.isPresentedProgressView = false
                    self.isPresentedErrorText = true
                    completion(false)
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                
                for id in idArray {
                    
                    dispatchGroup.enter()
                    
                    self.filterOptionsNavigatorForFollowingsOnly(userUID: id, isFollowing: false) { filteredHappeningsArray in
                        
                        if let filteredHappeningsArray = filteredHappeningsArray {
                            
                            for arrayItem in filteredHappeningsArray {
                                tempArray.append(arrayItem)
                            }
                        }
                        
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.happeningsDataArray = self.sortHappenings(array: tempArray)
                    print("Happenings Of Users Except Followings & Me Have Been Created Successfully. 👍🏻👍🏻👍🏻")
                    self.isPresentedProgressView = false
                    completion(true)
                }
            }
        }
    }
    
    // MARK: filterOptionsNavigator
    private func filterOptionsNavigatorForFollowingsOnly(userUID:String, isFollowing: Bool, completion: @escaping (_ filteredHappeningsArray: [HappeningItemModel]?) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(nil)
            return
        }
        
        var happeningsArray = [HappeningItemModel]()
        
        self.db
            .collection("Users/\(userUID)/HappeningData")
            .whereField("DueFlag", isEqualTo: "live")
            .whereField("SpaceFlag", isEqualTo: "open")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.documents.isEmpty else {
                        print("query snapshot nil.")
                        completion(nil)
                        return
                    }
                    
                    self.getProfileDataOfAnyUser(userUID: userUID) { profileDataSet in
                        guard let dataSet1 = profileDataSet else {
                            print("profile data set nil.")
                            completion(nil)
                            return
                        }
                        
                        for document in querySnapshot.documents {
                            
                            let array = document.get("Participators") as? [String] ?? []
                            
                            if array.contains(myUserUID) {
                                continue
                            }
                            
                            let dataSet2 = document.data()
                            
                            var mergedDataSet = dataSet1
                            
                            mergedDataSet.merge(dataSet2) {(current, _) in current}
                            
                            let object = HappeningItemModel(data: mergedDataSet, happeningDocID: document.documentID, followingStatus: isFollowing)
                            
                            happeningsArray.append(object)
                        }
                        
                        print("Happening Data Sets Has Been Retrieved Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                        
                        // now we have an array full of happenings related to one person.
                        
                        // pass the happening array to the top sorting option in the hierarchy.
                        
                        let filteredArray = self.filterRatings(
                            array: self.filterCityOrProvinceOrNearMe(
                                array: self.filterSpaceFee(
                                    array: happeningsArray
                                )
                            )
                        )
                        
                        print("One Of The Filtered Arrays Have Been Created Successfully. ❤️❤️❤️")
                        completion(filteredArray)
                    }
                }
            }
    }
    
    // MARK: 1. sortHappenings
    private func sortHappenings(array: [HappeningItemModel]) -> [HappeningItemModel] {
        
        if isSelectedHappeningSoonerButton {
            
            print("'Happening Sooner Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.sorted { $0.ssdt < $1.ssdt } // should be - to +
            
        } else if isSelectedHappeningLaterButton {
            
            print("'Happening Later Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.sorted { $0.ssdt > $1.ssdt} // should be - to +
            
        } else {
            print("No Happening Sooner OR Later Filtered. ⤵️⤵️⤵️")
            return array
        }
    }
    
    // MARK: 2 & 3. filterSpaceFee
    private func filterSpaceFee(array: [HappeningItemModel]) -> [HappeningItemModel] {
        
        if self.isSelectedFreeButton { // free only
            
            print("'Free Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.spaceFee.localizedCaseInsensitiveContains("Free") }
            
        } else if isSelectedPaidButton && minSpaceFeeTextFieldText.isEmpty && maxSpaceFeeTextFieldText.isEmpty { // paid only
            
            print("'Paid Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.spaceFeeNo > 0 }
            
        } else if !minSpaceFeeTextFieldText.isEmpty && maxSpaceFeeTextFieldText.isEmpty { // min only
            
            print("'Min Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.spaceFeeNo >= Int(minSpaceFeeTextFieldText)! }
            
        } else if !maxSpaceFeeTextFieldText.isEmpty && minSpaceFeeTextFieldText.isEmpty { // max only
            
            print("'Max Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.spaceFeeNo <= Int(maxSpaceFeeTextFieldText)! }
            
        } else if !maxSpaceFeeTextFieldText.isEmpty && !minSpaceFeeTextFieldText.isEmpty { // min & max
            
            print("'Min & Max' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.spaceFeeNo >= Int(minSpaceFeeTextFieldText)! &&  $0.spaceFeeNo <= Int(maxSpaceFeeTextFieldText)! }
            
        } else {
            print("No Space Fee OR Its Ranage Filtered. ⤵️⤵️⤵️")
            return array
        }
    }
    
    // MARK: 4. filterCityOrProvinceOrNearMe
    private func filterCityOrProvinceOrNearMe(array: [HappeningItemModel]) -> [HappeningItemModel] {
        
        let editProfileDataArray = EditProfileViewModel.shared.editProfileDataArray
        
        let myStreet1: String = editProfileDataArray.isEmpty ? "" : editProfileDataArray[0].street1
        let myStreet2: String = editProfileDataArray.isEmpty ? "" : editProfileDataArray[0].street2
        let myCity: String = editProfileDataArray.isEmpty ? "" : editProfileDataArray[0].city
        
        if !cityOrProvinceTextFieldText.isEmpty { // city/provice only
            
            print("'City/Provice Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter {
                followingsOnlyStatus == .on ?
                (
                    $0.secureAddress.localizedCaseInsensitiveContains(cityOrProvinceTextFieldText)
                    ||
                    $0.address.localizedCaseInsensitiveContains(cityOrProvinceTextFieldText)
                )
                :
                (
                    $0.secureAddress.localizedCaseInsensitiveContains(cityOrProvinceTextFieldText)
                )
                
            }
            
        } else if isSelectedNearMeButton { // near me only
            
            print("'Near Me Only' Has Been Filtered Successfully. ❤️❤️❤️")
            
            return array.filter {
                $0.address.localizedCaseInsensitiveContains(myStreet1)
                ||
                $0.address.localizedCaseInsensitiveContains(!myStreet2.isEmpty ? myStreet2 : myStreet1)
                ||
                $0.address.localizedCaseInsensitiveContains(myCity)
            }
            
        } else {
            print("No City/Profince OR Near Me Filtered. ⤵️⤵️⤵️")
            return array
        }
    }
    
    // MARK: filterRatings
    private func filterRatings(array: [HappeningItemModel]) -> [HappeningItemModel] {
        
        if isSelected5StarsButton {
            
            print("'5 Stars Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.ratings == 5 }
            
        } else if isSelected4StarsNupButton {
            
            print("'4 Stars & Up Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.ratings >= 4 }
            
        } else if isSelected3StarsNupButton {
            
            print("'3 Stars & Up Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.ratings >= 3 }
            
        } else if isSelected2StarsNupButton {
            
            print("'2 Stars & Up Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.ratings >= 2 }
            
        } else if isSelected1StarNupButton {
            
            print("'1 Star & Up Only' Has Been Filtered Successfully. ❤️❤️❤️")
            return array.filter { $0.ratings >= 1 }
            
        } else {
            print("No Ratings Filtered. ⤵️⤵️⤵️")
            return array
        }
    }
    
    // MARK: filterResults
    private func filterResults(text: String) {
        if(text.isEmpty) {
            filteredHappeningsDataArray = happeningsDataArray
        } else {
            filteredHappeningsDataArray = happeningsDataArray.filter {
                $0.title.localizedCaseInsensitiveContains(text)
                ||
                $0.userName.localizedCaseInsensitiveContains(text)
                ||
                (followingsOnlyStatus == .on ? $0.address.localizedCaseInsensitiveContains(text) : $0.secureAddress.localizedCaseInsensitiveContains(text))
                ||
                $0.ssdt.localizedCaseInsensitiveContains(text)
                ||
                $0.startingDateTime.localizedCaseInsensitiveContains(text)
                ||
                $0.spaceFee.localizedCaseInsensitiveContains(text)
                ||
                String($0.spaceFeeNo).localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    // MARK: payForAHappening
    func payForAHappening(userUID: String, happeningDocID: String, completion: @escaping (_ status: Bool) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(false)
            return
        }
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "userUID": myUserUID,
            "creatorID": userUID,
            "happeningDocID": happeningDocID
        ]
        
        functions.httpsCallable("reserveASpace").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        completion(false)
                        return
                    }
                
                if status {
                    print("Happening Payment With Apple Has Been Proceed Successfully. ❤️❤️❤️")
                    ReservedHViewModel.shared.getReservedHappeningItems { _ in }
                    completion(true)
                } else {
                    print("Server Error. ☠️☠️☠️")
                    completion(false)
                }
            }
        }
    }
}
