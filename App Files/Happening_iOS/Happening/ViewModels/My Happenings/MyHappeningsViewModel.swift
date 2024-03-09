//
//  MyHappeningsViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-14.
//

import Foundation
import Firebase
import CoreMedia
import SwiftUI

class MyHappeningsViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = MyHappeningsViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // reference to User Defaults
    let defaults = UserDefaults.standard
    
    // controls the search text of the my happening search bar
    @Published var searchText: String = "" {
        didSet {
            filterResults(text: searchText)
        }
    }
    
    // states whether the user is searching something or not
    @Published var isSearching: Bool = false
    
    // order selection of the time of the my happenings
    @Published var myCurrentHappeningSortingSelection: HappeningSortingTypes = .sooner {
        didSet {
            updateOrderedArray(type: myCurrentHappeningSortingSelection)
        }
    }
    
    // store all of my current happenings in this array that confirms to MyHappeningModel
    @Published var myCurrentHappeningItemsArray = [MyHappeningModel]() {
        didSet {
            updateOrderedArray(type: myCurrentHappeningSortingSelection)
        }
    }
    
    // store all of my ended happenings in this array that confirms to MyHappeningModel
    @Published var myEndedHappeningItemsArray = [MyHappeningModel]() {
        didSet {
            orderedMyEndedHappeningItemsArray = myEndedHappeningItemsArray.sorted { $0.ssdt > $1.ssdt}
        }
    }
    
    // store all of the ordered my current happenings in this array that confirms to MyHappeningModel
    @Published var orderedMyCurrentHappeningItemsArray = [MyHappeningModel]()
    
    // store all of the ordered my ended happenings in this array that confirms to MyHappeningModel
    @Published var orderedMyEndedHappeningItemsArray = [MyHappeningModel]()
    
    // present an alert item for MyHappeningsView
    @Published var alertItemForMyHappeningsView: AlertItemModel?
    
    // a timer that controls excecutions happen every 5 minutes.
    let fiveMinTimer = Timer.publish(every: 5*60, on: .main, in: .common).autoconnect()
    
    // firestore snapshot listner registers that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener1: ListenerRegistration?
    var firestoreListener2: ListenerRegistration?
    
    // a user defaults key name to store profile data of my happening's participants
    let participantsProfileDataArrayUserDefaultsKeyname: String = "ParticipantsProfileData"
    
    // an array that contains all of my happenings participants profile data
    @Published var participantsProfileDataArray = [ParticipantBasicProfileDataModel]()
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getMyCurrentHappeningsFromFirestore
    func getMyCurrentHappeningsFromFirestore() {
        
        guard let docID = currentUser.currentUserUID else {
            alertItemForMyHappeningsView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
            return
        }
        
        firestoreListener1?.remove()
        firestoreListener1 = db
            .collection("Users/\(docID)/HappeningData")
            .whereField("DueFlag", isEqualTo: "live")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.alertItemForMyHappeningsView = AlertItemModel(title: "Unable to Retrieve", message: error.localizedDescription)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot else {
                        self.alertItemForMyHappeningsView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                        return
                    }
                    
                    self.myCurrentHappeningItemsArray.removeAll() // for safety reasons
                    
                    for document in querySnapshot.documents {
                        
                        let data = document.data()
                        let documentID = document.documentID
                        
                        let object = MyHappeningModel(data: data, documentID: documentID)
                        
                        self.myCurrentHappeningItemsArray.append(object)
                        
                        let participantsIDArray: [String] = document.get("Participators") as? [String] ?? []
                        
                        for id in participantsIDArray {
                            
                            let tempArray: [ParticipantBasicProfileDataModel] = self.getParticipantsProfileDataArrayFromUserDefaults()
                            
                            if !tempArray.contains(where: { $0.userUID == id }) {
                                self.getProfileDataOfAUserFromFirestore(participatorUID: id) { status in
                                    if status == .error { return }
                                }
                            }
                        }
                    }
                    print("My Happening Current Document/s Has Been Retreived Successfully. 👍🏻👍🏻👍🏻")
                }
            }
    }
    
    
    // MARK: updateOrderedArray
    func updateOrderedArray(type: HappeningSortingTypes) {
        if(type == .sooner) {
            orderedMyCurrentHappeningItemsArray = myCurrentHappeningItemsArray.sorted { $0.ssdt < $1.ssdt} // should be - to +
        } else {
            orderedMyCurrentHappeningItemsArray = myCurrentHappeningItemsArray.sorted { $0.ssdt > $1.ssdt} // should be + to -
        }
    }
    
    
    // MARK: filterResults
    func filterResults(text: String) {
        if(text.isEmpty) {
            orderedMyCurrentHappeningItemsArray = myCurrentHappeningItemsArray
            updateOrderedArray(type: myCurrentHappeningSortingSelection)
            
            orderedMyEndedHappeningItemsArray = myEndedHappeningItemsArray
        } else {
            orderedMyCurrentHappeningItemsArray = myCurrentHappeningItemsArray.filter { $0.title.localizedCaseInsensitiveContains(text) }
            orderedMyEndedHappeningItemsArray = myEndedHappeningItemsArray.filter { $0.title.localizedCaseInsensitiveContains(text) }
        }
    }
    
    
    // MARK: endHappenings
    func endHappenings() { // make this as a cloud function later...
        
        guard let uid = currentUser.currentUserUID else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dtNow = formatter.string(from: Date.now)
        
        if !myCurrentHappeningItemsArray.isEmpty {
            
            var array = [String]()
            
            for item in myCurrentHappeningItemsArray {
                if item.sedt < dtNow {
                    array.append(item.id)
                }
            }
            
            let data: [String:Any] = [
                "SpaceFlag": "closed",
                "DueFlag": "ended"
            ]
            
            if !array.isEmpty {
                
                for id in array {
                    
                    db
                        .collection("Users/\(uid)/HappeningData")
                        .document(id)
                        .updateData(data) { error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                return
                            } else {
                                print("Some Happenings Have Been Flaged As Ended Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                            }
                        }
                }
            }
            
        } else {
            return
        }
    }
    
    
    // MARK: getMyEndedHappeningsFromFirestore
    func getMyEndedHappeningsFromFirestore() {
        
        guard let docID = currentUser.currentUserUID else {
            alertItemForMyHappeningsView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
            return
        }
        
        firestoreListener2?.remove()
        firestoreListener2 = db
            .collection("Users/\(docID)/HappeningData")
            .whereField("DueFlag", isEqualTo: "ended")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.alertItemForMyHappeningsView = AlertItemModel(title: "Unable to Retrieve", message: error.localizedDescription)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot else {
                        self.alertItemForMyHappeningsView = AlertItemModel(title: "Unable to Retrieve", message: "Please try again in a moment.")
                        return
                    }
                    
                    self.myEndedHappeningItemsArray.removeAll() // for safety reasons
                    
                    for document in querySnapshot.documents {
                        
                        let data = document.data()
                        let documentID = document.documentID
                        
                        let object = MyHappeningModel(data: data, documentID: documentID)
                        
                        self.myEndedHappeningItemsArray.append(object)
                    }
                    
                    print("MyHappening Ended Document/s Has Been Retreived Successfully. 👍🏻👍🏻👍🏻")
                }
            }
    }
    
    
    // MARK: getProfileDataOfAUser
    func getProfileDataOfAUserFromFirestore(participatorUID: String, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        db
            .collection("Users/\(participatorUID)/ProfileData")
            .addSnapshotListener { querySnapshot, error in
                print("Snapshot Listener For '(\(participatorUID)') Participator's Profile Data Just Fired. 🔥🔥🔥")
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error)
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("either querySnapshot nil or no documents available.")
                        completion(.error)
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        
                        let data = document.data()
                        let docID = document.documentID
                        
                        let object = ParticipantBasicProfileDataModel(data: data, documentID: docID)
                        
                        self.saveParticipantsProfileDataToUserDefaults(object: object)
                        completion(.success)
                    }
                }
            }
    }
    
    
    // MARK: getParticipantsProfileDataArrayFromUserDefaults
    func getParticipantsProfileDataArrayFromUserDefaults() -> [ParticipantBasicProfileDataModel] {
        
        if let data = defaults.data(forKey: participantsProfileDataArrayUserDefaultsKeyname) {
            do {
                /// we need a json decoder  to decode encoded data
                let decoder = JSONDecoder()
                /// now we can decode data into an array of objects using json decoder
                let array = try decoder.decode([ParticipantBasicProfileDataModel].self, from: data)
                /// once the data has been decoded to an array of objects, we can return them out of the function
                return array
            } catch {
                print("Unable To Decode.\nError: \(error) 🚫🚫🚫")
                /// if there's an error while decodeing data into an array of objects, we will return a nil array of objects
                return []
            }
        } else {
            /// if user defaults doesn't have any data, we will return a nil array of objects
            return []
        }
    }
    
    
    // MARK: saveParticipantsProfileDataArrayToUserDefaults
    func saveParticipantsProfileDataToUserDefaults(object: ParticipantBasicProfileDataModel) {
        
        var tempArray: [ParticipantBasicProfileDataModel] = getParticipantsProfileDataArrayFromUserDefaults()
        
        tempArray.removeAll(where: { $0.userUID == object.userUID })
        
        tempArray.append(object)
        
        do {
            /// we need a json encorder  to encode array data
            let encoder = JSONEncoder()
            
            /// encoding array of objects to data using json encoder
            let data = try encoder.encode(tempArray)
            
            /// save rest of the array data back to user defaults
            defaults.set(data, forKey: participantsProfileDataArrayUserDefaultsKeyname)
            
            participantsProfileDataArray = getParticipantsProfileDataArrayFromUserDefaults()
            print("All Of My Happening Participants Profile Data Has Been Saved In User Defaults Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
        } catch {
            print("Unable To Encode.\nError: \(error) 🚫🚫🚫")
            return
        }
    }
}
