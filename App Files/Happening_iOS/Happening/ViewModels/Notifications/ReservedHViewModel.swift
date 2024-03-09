//
//  ReservedHViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-10.
//

import Foundation
import Firebase
import SwiftUI

class ReservedHViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = ReservedHViewModel()
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to ContentViewModel class
    let contentVM = ContentViewModel.shared
    
    // reference to NotifiationManager class
    let notificationManager = NotificationManager.shared
    
    // this will store all the reserved happening items data
    @Published var reservedHappeningsItemArray = [HappeningItemModel]() {
        didSet {
            filteredReservedHappeningsItemArray = reservedHappeningsItemArray
        }
    }
    
    // this will store all the filtered happening items data
    @Published var filteredReservedHappeningsItemArray = [HappeningItemModel]() {
        didSet {
            if !filteredReservedHappeningsItemArray.isEmpty {
                resetReservedHProgress()
            }
        }
    }
    
    // controls the searching text of the reserved happening notification
    @Published var searchTextReservedH: String = "" {
        didSet {
            filterResults(reservedHText: searchTextReservedH)
            
            if !searchTextReservedH.isEmpty && filteredReservedHappeningsItemArray.isEmpty {
                noResultsFoundForReservedH()
            }
        }
    }
    
    // state whether the user is searching something on reserved happening notifications
    @Published var isSearchingReservedH: Bool = false
    
    // controls the presentation of processing for ReservedH
    @Published var showProgressViewForReservedH: Bool = false
    @Published var showNoResultsFoundForReservedH: Bool = false
    @Published var showNoHappeningsForReservedH: Bool = false
    
    // controls the sheet to happening soon item sheet
    @Published var isPresentedHappeningSoonItemSheet: Bool = false
    
    // controls the blinking opacity of the happeing soon list item view
    @Published var happeningSoonListItemViewOpacity: CGFloat = 0.5
    
    // MARK: FUNCTIONS
    
    
    // MARK: getReservedHappeningsFromFirestore
    func getReservedHappeningsFromFirestore(completion: @escaping (_ dataArray: [ReserevedHappeningModel]?) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(nil)
            return
        }
        
        db
            .collection("Users/\(myUserUID)/ReservedHappenings")
            .whereField("isEnded", isEqualTo: false)
            .order(by: "TimeStamp")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("query snapshot nil or no documents available.")
                        completion(nil)
                        return
                    }
                    
                    var reservedHappeningDataArray = [ReserevedHappeningModel]()
                    
                    for document in querySnapshot.documents {
                        let data = document.data()
                        let object = ReserevedHappeningModel(data: data)
                        
                        reservedHappeningDataArray.append(object)
                    }
                    
                    print("Reserved Happenings Data Has Been Retrieved Successfully. ❤️❤️❤️")
                    completion(reservedHappeningDataArray)
                }
            }
    }
    
    // MARK: getProfileDataOfAUserFromFirestore
    func getProfileDataOfAUserFromFirestore(userID: String, completion: @escaping (_ data: [String:Any]?) -> ()) {
        
        db
            .collection("Users/\(userID)/ProfileData")
            .document(userID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                } else {
                    
                    guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                        print("document snapshot nil or not exsist.")
                        completion(nil)
                        return
                    }
                    
                    print("Profile Data of \(userID) Has Been Retrieved Successfully. ❤️❤️❤️")
                    completion(documentSnapshot.data())
                }
            }
    }
    
    // MARK: getHappeningDataOfAUserFromFirestore
    func getHappeningDataOfAUserFromFirestore(userID: String, happeningDocID: String, completion: @escaping (_ data: [String:Any]?) -> ()) {
        
        db
            .collection("Users/\(userID)/HappeningData")
            .document(happeningDocID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                } else {
                    
                    guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                        print("document snapshot nil or not exsist.")
                        completion(nil)
                        return
                    }
                    
                    print("Happening Data of \(userID) - \(happeningDocID) Has Been Retrieved Successfully. ❤️❤️❤️")
                    completion(documentSnapshot.data())
                }
            }
    }
    
    // MARK: getReservedHappeningItemsFromFirestore
    func getReservedHappeningItems(completion: @escaping (_ status: Bool) -> ()) {
        
        reservedHappeningsItemArray.removeAll() // for safety reasons.
        filteredReservedHappeningsItemArray.removeAll() // for safety reasons.
        progressViewForReservedH()
        
        let group = DispatchGroup()
        
        getReservedHappeningsFromFirestore { array in
            guard let array = array else {
                print("reserved happenings data array nil.")
                self.noHappeningsForReservedH()
                completion(false)
                return
            }
            
            var tempArray = [HappeningItemModel]()
            
            for item in array {
                
                var dataSet1 = [String:Any]()
                var dataSet2 = [String:Any]()
                
                group.enter()
                self.getProfileDataOfAUserFromFirestore(userID: item.creatorUID) { data in
                    
                    guard let profileDataOfAUser = data else {
                        print("profile data nil.")
                        self.noHappeningsForReservedH()
                        completion(false)
                        return
                    }
                    
                    dataSet1 = profileDataOfAUser
                    
                    self.getHappeningDataOfAUserFromFirestore(userID: item.creatorUID, happeningDocID: item.happeningDocID) { data in
                        
                        guard let happeningDataOfAUser = data else {
                            print("happening data nil.")
                            self.noHappeningsForReservedH()
                            completion(false)
                            return
                        }
                        
                        dataSet2 = happeningDataOfAUser
                        
                        var mergedDataSet = dataSet1
                        
                        mergedDataSet.merge(dataSet2) {(current, _) in current}
                        
                        let object = HappeningItemModel(data: mergedDataSet, happeningDocID: item.happeningDocID, followingStatus: true)
                        
                        tempArray.append(object)
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.reservedHappeningsItemArray = tempArray.sorted { $0.ssdt < $1.ssdt } // should be - to +
                print("Reserved Happeings Array Has Been Created & Sorted Successfully. ❤️❤️❤️")
                completion(true)
            }
        }
    }
    
    // MARK: filterResults - reservedHText
    private func filterResults(reservedHText: String) {
        if(reservedHText.isEmpty) {
            filteredReservedHappeningsItemArray = reservedHappeningsItemArray
        } else {
            filteredReservedHappeningsItemArray = reservedHappeningsItemArray.filter {
                $0.title.localizedCaseInsensitiveContains(reservedHText)
                ||
                $0.userName.localizedCaseInsensitiveContains(reservedHText)
                ||
                $0.ssdt.localizedCaseInsensitiveContains(reservedHText)
                ||
                $0.startingDateTime.localizedCaseInsensitiveContains(reservedHText)
                ||
                $0.spaceFee.localizedCaseInsensitiveContains(reservedHText)
                ||
                String($0.spaceFeeNo).localizedCaseInsensitiveContains(reservedHText)
                ||
                $0.address.localizedCaseInsensitiveContains(reservedHText)
            }
        }
    }
    
    // MARK: progressViewForReservedH
    func progressViewForReservedH() {
        showProgressViewForReservedH = true
        showNoResultsFoundForReservedH = false
        showNoHappeningsForReservedH = false
    }
    
    // MARK: noResultsFoundForReservedH
    func noResultsFoundForReservedH() {
        showProgressViewForReservedH = false
        showNoResultsFoundForReservedH = true
        showNoHappeningsForReservedH = false
    }
    
    // MARK: noHappeningsForReservedH
    func noHappeningsForReservedH() {
        showProgressViewForReservedH = false
        showNoResultsFoundForReservedH = false
        showNoHappeningsForReservedH = true
    }
    
    // MARK: resetReservedHProgress
    func resetReservedHProgress() {
        showProgressViewForReservedH = false
        showNoResultsFoundForReservedH = false
        showNoHappeningsForReservedH = false
    }
    
    // MARK: onAppearActions
    func onAppearActions() {
        let baseAnimation = Animation.easeInOut(duration: 0.5)
        let repeated = baseAnimation.repeatForever(autoreverses: true)
        withAnimation(repeated) {
            happeningSoonListItemViewOpacity = 0.2
        }
        
        // clear badge counts and notifiation counts
        contentVM.notificationViewBadgeCount = 0
        notificationManager.cancelDeliveredNotifications()
    }
    
    // MARK: onTapGestureActions
    func onTapGestureActions() {
        isPresentedHappeningSoonItemSheet = true
    }
}
