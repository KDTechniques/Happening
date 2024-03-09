//
//  MemoriesViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import Foundation
import SwiftUI
import Combine
import Firebase

final class MemoriesViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    static let shared = MemoriesViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to TextBasedMyMemoriesViewModel class
    let textBasedMemoriesVM = TextBasedMemoryViewModel.shared
    
    // reference to User Defaults
    let defaults = UserDefaults.standard
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // timer to give some time to properly view the memory image
    @Published var memoryProgressBartimer1 = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @Published var connectedTimer1: Cancellable? = nil
    
    // timer to give some time to properly view the memory image
    @Published var memoryProgressBartimer2 = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @Published var connectedTimer2: Cancellable? = nil
    
    // text comes from the search bar text field
    @Published var searchText = "" {
        didSet {
            if searchText.isEmpty {
                filteredFollowingsMemoriesDataArray = followingsMemoriesDataArray
            } else {
                filterResults(searchText: searchText)
            }
        }
    }
    
    // status whether the user started typing or not
    @Published var isSearching = false
    
    // present a sheet when user tap on the a status
    @Published var isPresentedStatusViewSheet: Bool = false
    
    // an array that stores failed n succeeded my memories data
    @Published var failedNSucceededMyMemoriesDataArray = [MyMemoriesModel]()
    
    // controls the selected index of my memories items
    @Published var selectedMyMemoryIndex: Int = 0
    
    // a timer that checks upload failed or pending memories count and let user know by displaying it
    var memoriesUploadStateCheckingTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var connectedTimer3: Cancellable? = nil
    
    // a timer that helps to reupload upload failed & pending my memories
    let myMemoriesReuploadingNRedeletingNFollowingMemoriesReflaggingTimer = Timer.publish(every: 10, tolerance: 5, on: .main, in: .common).autoconnect()
    
    // a user defaults key name to store pending upload my memories data array in user defaults
    let pendingUploadMyMemoriesDataArrayUserDefaultsKeyName: String = "PendingUploadMyMemoriesDataArray"
    
    // a user defaults key name to store failed my memories data array in user defaults
    let failedMyMemoriesDataArrayUserDefaultsKeyName: String = "FailedMyMemoriesDataArray"
    
    // a user defaults key name to store succeed & retrieved my memories data array in user defaults
    let myMemoriesDataArrayUserDefaultsKeyName: String = "MyMemoriesDataArray"
    
    // a user defaults key name to store deletion pending my memory items ids array in user defaults
    let deletionPendingMyMemoriesIDArrayUserDefaultsKeyName: String = "DeletionPendingMyMemoriesIDsArray"
    
    // this will state whether any deletion function is being called and deletion progress going on or not
    @Published var isDeletionInProgress: Bool = false
    
    // controls the rotation amount of the custom progress view that uses to indicate memory image loading progress
    @Published var rotationAmount: CGFloat = 0
    
    // a firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    // indicates the number of pending memories are uploading
    @Published var sendingCount: Int = 0
    
    // an array that stores all the followings memories data
    @Published var followingsMemoriesDataArray = [[FollowingsMemoriesModel]]() {
        didSet {
            if !isSearching && searchText.isEmpty {
                filteredFollowingsMemoriesDataArray = followingsMemoriesDataArray
            }
        }
    }
    
    // an array that stores filtered followings memories data
    @Published var filteredFollowingsMemoriesDataArray = [[FollowingsMemoriesModel]]()
    
    // a user defaults key name to store all of my followings memories data array in user defaults
    let myFollowingsMemoriesDataArrayUserDefaultsKeyName: String = "MyFollowingsMemoriesDataArray"
    
    // present a sheet to show followings memories data
    @Published var isPresentedMyFollowingsMemoriesSheet: Bool = false
    
    // an array that stores the selected folowing user's memories data
    @Published var selectedFollowingUserMemoriesDataArrayItem = [FollowingsMemoriesModel]()
    
    // selected index of the current memory item of the following user
    @Published var selectedFollowingsMemoryIndex: Int = 0 {
        didSet {
            guard let myUserUID = currentUser.currentUserUID else {
                print("my user uid nil.")
                return
            }
            
            let memoryItem = selectedFollowingUserMemoriesDataArrayItem[selectedFollowingsMemoryIndex]
            
            if !memoryItem.isSeen {
                let object = MemorySeenerModel(
                    id: memoryItem.id,
                    fullSeenDT: getCurrentDateAndTime(format: "MM-dd-yyyy HH:mm:ss"), // ex: 05-02-2022 19:47:19
                    seenDate: getCurrentDateAndTime(format: "MMM d, yyyy"),  // ex: May 22, 2022
                    seenTime: getCurrentDateAndTime(format: "h:mm a"), // ex: 4:46 PM
                    seenerUID: myUserUID,
                    followingUserUID: memoryItem.userUID
                )
                
                setFollowingsMemorySeenFlagInFirestoreNUserDefaults(memorySeenerModelObject: object)
            }
        }
    }
    
    // a user defaults key name to store pending memory seen flag items in an array
    @Published var failedMemorySeenFlagsUserDefaultsKeyName: String = "FailedMemorySeenFlags"
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: COMMON
    
    // MARK: pauseMemoryProgressBar
    func pauseMemoryProgressBar() {
        connectedTimer1?.cancel()
    }
    
    
    // MARK: resumeMemoryProgressBar
    func resumeMemoryProgressBar() {
        memoryProgressBartimer1 = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        connectedTimer1 = memoryProgressBartimer1.upstream.connect()
    }
    
    // MARK: pauseMemoryUploadDTCalculatorTimer
    func pauseMemoryUploadDTCalculatorTimer() {
        connectedTimer3?.cancel()
    }
    
    
    // MARK: resumeMemoryUploadDTCalculatorTimer
    func resumeMemoryUploadDTCalculatorTimer() {
        memoriesUploadStateCheckingTimer = Timer.publish(every: 2, tolerance: 2, on: .main, in: .common).autoconnect()
        connectedTimer3 = memoriesUploadStateCheckingTimer.upstream.connect()
    }
    
    
    // MARK: memoriesUploadedDateOrTimeCalculator
    /// this function will calculate time and return as a text such as 'just now', '1m ago', '1h ago', 'yesterday', etc...
    func memoriesUploadedDateOrTimeCalculator(fullUploadedDT: String, date: String, time: String) -> String {
        
        let dateNTime: String = "\(date) \(time)"
        
        var returnText: String = dateNTime
        
        /// full date and time format must be in "MM-dd-yyyy HH:mm:ss" --> "05-02-2022 19:47:19" to works perfectly
        
        /// 1 - first we need to seperate and get year, month, day, hours, minutes as single components to do the calculations with them
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy HH:mm:ss"
        df.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = df.date(from: fullUploadedDT) {
            
            let calendar = Calendar.current
            
            /// this will represent weekday number given by the calender weekday component
            /// sunday - 1
            /// monday - 2
            /// tuesday - 3
            /// wednesday - 4
            /// thursday - 5
            /// friday - 6
            /// saturday - 7
            
            let dayNameArray: [String] = [
                "Sunday",    // 0
                "Monday",    // 1
                "Tuesday",   // 2
                "Wednesday", // 3
                "Thursday",  // 4
                "Friday",    // 5
                "Saturday"   // 6
            ]
            
            let receivedYear = calendar.component(.year, from: date)
            let receivedMonth = calendar.component(.month, from: date)
            let receivedDayNo = calendar.component(.day, from: date)
            let receivedWeekDay = calendar.component(.weekday, from: date)
            let receivedDayName = dayNameArray[receivedWeekDay-1]
            
            let receivedHours = calendar.component(.hour, from: date)
            let receivedMinutes = calendar.component(.minute, from: date)
            
            let now = Date()
            let year = calendar.component(.year, from: now)
            let month = calendar.component(.month, from: now)
            let dayNo = calendar.component(.day, from: now)
            let weekDay = calendar.component(.weekday, from: now)
            let _ = dayNameArray[weekDay-1]
            
            let hours = calendar.component(.hour, from: now)
            let minutes = calendar.component(.minute, from: now)
            
            /// 2 - now we have all the date components we need to do the calculation
            /// followings are the required strings
            /// * just now
            /// * 1m ago - 59m ago ------------------------------------> solve this later
            /// * 1h ago - 23h ago -------------------------------------> solve this later
            /// * yesterday
            /// * monday - sunday
            /// * May 22, 2022 4:46 PM
            
            let todayDTAsString: String = "\(year) \(month) \(dayNo) \(hours) \(minutes)"
            let receivedDTAsString: String = "\(receivedYear) \(receivedMonth) \(receivedDayNo) \(receivedHours) \(receivedMinutes)"
            let todayYearNMonthAsString: String = "\(year) \(month)"
            let receivedYearNMonthAsString: String = "\(receivedYear) \(receivedMonth)"
            let endDayNoOfLastMonth: Int = getLastDayOfLastMonth()
            
            var dayDifference: Int {
                /// if this year and last year --> 2022 & 2021
                if receivedYear == year-1 {
                    /// if this year january and last year december
                    if month == 1 && receivedMonth == 12 {
                        return endDayNoOfLastMonth - receivedDayNo + dayNo
                    } else {
                        return 8 /// greater than  8 days --> dayDifference > 8
                    }
                }
                /// if within same year --> 2022
                else if receivedYear == year {
                    /// if within same month
                    if month - receivedMonth == 0 {
                        return dayNo - receivedDayNo
                    } else {
                        return 8 /// greater than 8 days --> dayDifference > 8
                    }
                } else {
                    return 8 /// greater than 8 days --> dayDifference > 8
                }
            }
            var hoursDifference: Int {
                /// if this year and last year --> 2022 & 2021
                if receivedYear == year-1 {
                    /// if this year january and last year december
                    if month == 1 && receivedMonth == 12 {
                        if dayDifference == 0 {
                            return receivedHours - hours
                        } else {
                            return 24 /// greater than 24 hours --> hoursDifference > 24
                        }
                    } else {
                        return 24 /// greater than 24 hours --> hoursDifference > 24
                    }
                }
                /// if within same year --> 2022
                else if receivedYear == year {
                    if month - receivedMonth == 0 {
                        if dayDifference == 0 {
                            return hours - receivedHours
                        } else {
                            return 24 /// greater than 24 hours --> hoursDifference >24
                        }
                    } else {
                        return 24 /// greater than 24 hours --> hoursDifference >24
                    }
                } else {
                    return 24 /// greater than 24 hours --> hoursDifference >24
                }
            }
            var minutesDifference: Int {
                if year == receivedYear && month == receivedMonth {
                    /// if within same day
                    if dayDifference == 0 {
                        /// if within same hour
                        if hoursDifference == 0 {
                            return minutes - receivedMinutes
                        } else {
                            return 60 /// greater than or equal to 60 minutes --> minutesDiffrence >= 60
                        }
                    } else {
                        return 60 /// greater than 60 minutes --> minutesDiffrence > 60
                    }
                } else {
                    return 60 /// greater than or equal to 60 minutes --> minutesDiffrence >= 60
                }
            }
            
            /// if received date and time exactly match with the current date and time, that means it's just now
            if todayDTAsString == receivedDTAsString {
                returnText = "just now"
            } else {
                /// even if the whole date and time doesn't match with each other but, current year and month match with received year and month
                if todayYearNMonthAsString == receivedYearNMonthAsString {
                    /// if both current and received days matches, that means it's today
                    if dayNo == receivedDayNo {
                        if minutesDifference < 60 {
                            returnText = "\(minutesDifference)m ago"
                        } else if hoursDifference >= 1 && hoursDifference < 24 {
                            returnText = "\(hoursDifference)h ago"
                        } else {
                            returnText = receivedDayName
                        }
                    }
                    /// both current and received days don't match but, their differnce is one day. so, that means it was yesterday
                    else if dayDifference == 1 {
                        returnText = "yesterday"
                    }
                    /// if the day difference is less than a week and greater than yesterday, that means it should be represented in day name
                    else if dayDifference > 1 && dayDifference < 8 {
                        returnText = receivedDayName
                    }
                } else {
                    /// if current year and month doesn't match with the receieved year and month, that means either it's not this year or this month.
                    /// let's only consider that it's not this month, that means it could be last month or lesser than that.
                    /// if current day is the first day of the month, then yesterday must be the end day of the last month
                    /// if current day is 1 and end day of last month equal to received month and day, that means it's also yesterday
                    if (year == receivedYear) && (month - receivedMonth == 1) && (dayNo == 1 && receivedDayNo == getLastDayOfLastMonth()) {
                        returnText = "yesterday"
                    }
                }
            }
            
            return returnText
        } else {
            return dateNTime
        }
    }
    
    
    
    
    
    // MARK: MY MEMORIES <<--------------------------------------------------------------------------
    
    // MARK: getMyMemoriesDataFromUserDefaults
    /// this function will get all of my memories data from user defaults and stoe that data in an array, so we can access it in a list
    func getMyMemoriesDataFromUserDefaults() {
        
        // Related to My Memories
        // Pending
        let tempPendingUploadMyMemoriesDataArray = getExistingCustomMyMemoriesDataFromUserDefaults(keyName: pendingUploadMyMemoriesDataArrayUserDefaultsKeyName)
        
        // Failed
        let tempFailedMyMemoriesDataArray = getExistingCustomMyMemoriesDataFromUserDefaults(keyName: failedMyMemoriesDataArrayUserDefaultsKeyName)
        
        // Uploaded aka succeed
        let tempSucceedMyMemoriesDataArray = getExistingCustomMyMemoriesDataFromUserDefaults(keyName: myMemoriesDataArrayUserDefaultsKeyName)
        
        // order doesn't matter when combining arrays, beause we're sorting it by 'fullUploadDT'
        let tempArray = tempPendingUploadMyMemoriesDataArray + tempFailedMyMemoriesDataArray + tempSucceedMyMemoriesDataArray
        
        // sort the whole array indexes by its uploaded date
        DispatchQueue.main.async {
            self.failedNSucceededMyMemoriesDataArray = tempArray.sorted { $0.fullUploadedDT < $1.fullUploadedDT }
        }
    }
    
    
    // MARK: getExistingCustomMyMemoriesDataFromUserDefaults
    // this function get data from an required array in user defaults and return the data that conforms to 'MyMemoriesModel'
    func getExistingCustomMyMemoriesDataFromUserDefaults(keyName: String) -> [MyMemoriesModel] {
        /// first we get the data in data format from user defaults.
        if let data = defaults.data(forKey: keyName) {
            do {
                /// we need a json decoder  to decode encoded data
                let decoder = JSONDecoder()
                /// now we can decode data into an array of objects using json decoder
                let array = try decoder.decode([MyMemoriesModel].self, from: data)
                /// once the data has been decoded to an array of objects, we can return them out of the function
                return array
            } catch {
                print("Unable To Decode.\nError: \(error) 🚫🚫🚫")
                /// if there's an error while decodeing data into an array of objects, we will return a nil array of objects
                return []
            }
        } else {
            /// if user defulats doesn't have any data in name of given name, we will return a nil array of objects
            return []
        }
    }
    
    
    // MARK: createATextBasedMemoryAsAnUIImage
    /// this function will take all the necessary properties to create a perfect textbased uiimage and return it.
    ///  this function will help full we we want to get text based memory data from firestore and display them on a view by converting the downloaded data to an uiimage
    func createATextBasedMemoryAsAnUIImage(text: String, colorName: String, fontName: String) -> UIImage {
        
        /// provide all the required property values to create a proper text based memory image
        textBasedMemoriesVM.__textEditortext = text
        textBasedMemoriesVM.__colorName = colorName
        textBasedMemoriesVM.__fontName = fontName
        
        textBasedMemoriesVM.onChangeOfTextEditorText()
        
        return TextBasedMemoryTextEditorViewAsImage().asImage()
    }
    
    
    // MARK: handlePendingUploadMyMemories
    /// when user creates a memory, it will be saved to pending memory items array in user defaults, so if somethings goes wrong while uploading, we can reupload the memory by taking that purticular memory from pending memories array in user defaults
    func handlePendingUploadMyMemories(docID: String, storingData: [String:Any], compressedThumbnailImageData: Data, compressedImageData: Data) {
        
        var tempPendingUploadMyMemoriesDataArray = [MyMemoriesModel]()
        
        let object = MyMemoriesModel(uuid: docID, data: storingData, compressedThumbnailImageData: compressedThumbnailImageData, compressedImageData: compressedImageData, seenersData: [], uploadStatus: .pending)
        
        /// get existing data from user defaults
        tempPendingUploadMyMemoriesDataArray = getExistingCustomMyMemoriesDataFromUserDefaults(keyName: pendingUploadMyMemoriesDataArrayUserDefaultsKeyName)
        
        /// save appended memory object item array to user defaults
        saveCustomMemoriesDataToUserDefaults(
            object: object,
            array: tempPendingUploadMyMemoriesDataArray,
            keyName: pendingUploadMyMemoriesDataArrayUserDefaultsKeyName
        )
    }
    
    
    // MARK: handleUploadFailedMyMemories
    /// when user creates a memory, it will be saved to pending memory items array in user defaults, so if somethings goes wrong while uploading, we can reupload the memory by taking that purticular memory from pending memories or failed memory items array in user defaults
    func handleUploadFailedMyMemories(docID: String, storingData: [String:Any], compressedThumbnailImageData: Data, compressedImageData: Data) {
        
        var tempFailedMyMemoriesDataArray = [MyMemoriesModel]()
        
        let object = MyMemoriesModel(uuid: docID, data: storingData, compressedThumbnailImageData: compressedThumbnailImageData, compressedImageData: compressedImageData, seenersData: [], uploadStatus: .failed)
        
        /// get existing data from user defaults
        tempFailedMyMemoriesDataArray = getExistingCustomMyMemoriesDataFromUserDefaults(keyName: failedMyMemoriesDataArrayUserDefaultsKeyName)
        
        /// save appended memory object item array to user defaults
        saveCustomMemoriesDataToUserDefaults(
            object: object,
            array: tempFailedMyMemoriesDataArray,
            keyName: failedMyMemoriesDataArrayUserDefaultsKeyName
        )
    }
    
    
    // MARK: handleUploadSucceedMyMemories
    /// once the memory is uploaded to firestore without any problem, that purticular memory will be saved in array called uploaded memory items array in user defaults
    func handleUploadSucceedMyMemories(docID: String, storingData: [String:Any], compressedThumbnailImageData: Data, compressedImageData: Data) {
        
        var tempSucceedMyMemoriesDataArray = [MyMemoriesModel]()
        
        let object = MyMemoriesModel(uuid: docID, data: storingData, compressedThumbnailImageData: compressedThumbnailImageData, compressedImageData: compressedImageData, seenersData: [], uploadStatus: .uploaded)
        
        /// get existing data from user defaults
        tempSucceedMyMemoriesDataArray = getExistingCustomMyMemoriesDataFromUserDefaults(keyName: myMemoriesDataArrayUserDefaultsKeyName)
        
        /// save appended memory object item array to user defaults
        saveCustomMemoriesDataToUserDefaults(
            object: object,
            array: tempSucceedMyMemoriesDataArray,
            keyName: myMemoriesDataArrayUserDefaultsKeyName
        )
    }
    
    
    // MARK: saveCustomMemoriesDataToUserDefaults
    /// this function will take a custom object with an exsisting data array and change its upload status and append it to the exsiting array and encode it and save it to user defaults in data format
    func saveCustomMemoriesDataToUserDefaults(object: MyMemoriesModel, array: [MyMemoriesModel], keyName: String) {
        
        var tempObject: MyMemoriesModel = object
        var tempArray: [MyMemoriesModel] = array
        
        /// if condition for safety reasons and to avoid object duplication
        if !array.contains(where: { $0.id == object.id }) {
            
            switch keyName {
            case pendingUploadMyMemoriesDataArrayUserDefaultsKeyName: /// this block will excecute when you want to save data to upload pending array in user defaults
                /// change the current object's 'uploadStatus' to 'pending'
                tempObject.uploadStatus = .pending
                tempArray.append(tempObject)
                
            case failedMyMemoriesDataArrayUserDefaultsKeyName: /// this block will excecute when you want to save data to upload failed array in user defaults
                /// change the current object's 'uploadStatus' to 'failed'
                tempObject.uploadStatus = .failed
                tempArray.append(tempObject)
                
            case myMemoriesDataArrayUserDefaultsKeyName: /// this block will excecute when you want to save data to upload succeed array in user defaults
                /// change the current object's 'uploadStatus' to 'uploaded'
                tempObject.uploadStatus = .uploaded
                tempArray.append(tempObject)
                
            default: return
            }
            
            /// once the object has been appended to the related array, we need to remove that object from the rest of the arrays in user defaults unless we will get memory data confliction
            do {
                let encoder = JSONEncoder()
                
                let data = try encoder.encode(tempArray)
                
                // save data to user defaults
                defaults.set(data, forKey: keyName)
                
                /// remove a purticular memory data set from another purticular array in user defaults, once that data set has been saved to another array in user defaults
                switch object.uploadStatus {
                case .pending: /// this block will excecute after saving a purticular memory data set to pending my memories items array in user defaults
                    /// once the data has been saved to user defaults, remove that purticular data set from the failed array in the user defaults
                    removeACustomMyMemoriesDataFromUserDefaults(id: object.id, keyName: failedMyMemoriesDataArrayUserDefaultsKeyName)
                    
                case .failed: /// this block will excecute after saving a purticular memory data set to failed my memories items array in user defaults
                    /// once the data has been saved to user defaults, remove that purticular data set from the pending array in the user defaults
                    removeACustomMyMemoriesDataFromUserDefaults(id: object.id, keyName: pendingUploadMyMemoriesDataArrayUserDefaultsKeyName)
                    
                case .uploaded: /// this block will excecute after saving a purticular memory data set to succeed my memories items array in user defaults
                    /// once the data has been saved to user defaults, remove that purticular data set from the pending array in the user defaults
                    removeACustomMyMemoriesDataFromUserDefaults(id: object.id, keyName: pendingUploadMyMemoriesDataArrayUserDefaultsKeyName)
                }
                print("A Purticular My Memories Data Has Been Saved In User Defaults Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
            } catch {
                print("Unable To Encode.\nError: \(error) 🚫🚫🚫")
                return
            }
        }
    }
    
    
    // MARK: saveCustomMemoriesDataToUserDefaults
    /// this function will take an array and save it to the realted array in user defaults in the name of given key name parameter
    func saveCustomMemoriesDataArrayToUserDefaults(array: [MyMemoriesModel], keyName: String) {
        
        /// we will use json encoder to convert array of objects into data
        do {
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(array)
            
            /// once the array has been encoded to data, it will be saved in related array in user defaults
            defaults.set(data, forKey: keyName)
            print("A Purticular My Memories Data Has Been Saved In User Defaults Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
        } catch {
            print("Unable To Encode.\nError: \(error) 🚫🚫🚫")
            return
        }
    }
    
    
    // MARK: removeACustomMemoriesDataFromUserDefaults
    func removeACustomMyMemoriesDataFromUserDefaults(id: String, keyName: String) {
        
        var tempArray = [MyMemoriesModel]()
        
        /// first we need to get the required data from user defaults according to given key name
        if let data = defaults.data(forKey: keyName) {
            do {
                /// we need json decoder to decode encoded data into an array of objects
                let decoder = JSONDecoder()
                
                /// data will be decoded into an array of objects that conforms to 'MyMemoriesModel'
                tempArray = try decoder.decode([MyMemoriesModel].self, from: data)
            } catch {
                print("Unable To Decode.\nError: \(error) 🚫🚫🚫")
                return
            }
            
            /// remove the given memory  id item from the purticular array from user defaults
            tempArray.removeAll(where: { $0.id == id })
            
            /// once the required item is deleted from the array, we need to encode it into data and save it in the user defaults
            do {
                let encoder = JSONEncoder()
                
                // encoding array of objects to data using json encoder
                let data = try encoder.encode(tempArray)
                
                /// save rest of the array data back to user defaults
                defaults.set(data, forKey: keyName)
                print("A Purticular My Memories Data Has Been Saved In User Defaults Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
            } catch {
                print("Unable To Encode.\nError: \(error) 🚫🚫🚫")
                return
            }
            print("\(id) Memory Item Has Been Removed From \(keyName) Array in User Defaults & The Rest Has Been Saved In User Defaults Successfully. 🍄🍄🍄")
        }
    }
    
    
    // MARK: deleteMyMemoryListItemFromUserDefaultsNFirestore
    func deleteMyMemoryListItemFromUserDefaultsNFirestore(indexSet: IndexSet) {
        
        /// this property is used to stop the timers that involves in refreshing the list items and its data
        /// when deletion progress is true, the timers will stops to avoid getting the deleted data back to the list
        /// that means we only refresh the list array item and its data when there's no deletion progress is happening in the background
        isDeletionInProgress = true
        
        /// the deleting item index in the 'failedNSucceededMyMemoriesDataArray'
        let index = indexSet.first!
        
        /// get the item id before deleting it
        let id: String = failedNSucceededMyMemoriesDataArray[index].id // memory doc id
        
        /// 1 - remove the item from the 'failedNSucceededMyMemoriesDataArray' for better ux
        /// we can delete the item using index instead index set, but that's okay because index set contains only one index as we don't have implemented the multiple deletions at once.
        failedNSucceededMyMemoriesDataArray.remove(at: index)
        
        /// 2 - once the item has been deleted from the  'failedNSucceededMyMemoriesDataArray', store that id in user defaults, so we can delete the item from database even if something goes wrong while deleting the item
        customDeletionFunction(id: id)
    }
    
    
    // MARK: customDeletionFunction
    private func customDeletionFunction(id: String) {
        
        /// this property is used to stop the timers that involves in refreshing the list items and its data
        /// when deletion progress is true, the timers will stops to avoid getting the deleted data back to the list
        /// that means we only refresh the list array item and its data when there's no deletion progress is happening in the background
        isDeletionInProgress = true
        
        /// 1 - we must remove the id as soon as possible from either pending uploading memory array or failed uploading memory array or succeed uploading memory array, because
        /// if we don't do that, the pending deleted data will be added to the memory list again even they are in pending deletion progress
        removeACustomMyMemoriesDataFromUserDefaults(id: id, keyName: pendingUploadMyMemoriesDataArrayUserDefaultsKeyName)
        removeACustomMyMemoriesDataFromUserDefaults(id: id, keyName: failedMyMemoriesDataArrayUserDefaultsKeyName)
        removeACustomMyMemoriesDataFromUserDefaults(id: id, keyName: myMemoriesDataArrayUserDefaultsKeyName)
        
        /// 2 - remove the item from 'failedNSucceededMyMemoriesDataArray' even when re-deleting a purticular item unless user will cofuse
        /// becase even if the item deleted from user defaults and firestore in the background, the item can still alive in 'failedNSucceededMyMemoriesDataArray'
        /// and it's not good for user experience
        failedNSucceededMyMemoriesDataArray.removeAll(where: { $0.id == id })
        
        /// 3 - store that id in pending deletion array in user defaults, so we can delete the item from database even if something goes wrong while deleting the item
        /// get the existing ids array from user defaults
        var tempArray: [String] = defaults.stringArray(forKey: deletionPendingMyMemoriesIDArrayUserDefaultsKeyName) ?? []
        
        /// append the new current id to that array
        /// same id will never append to an array even if there's something went wrong
        /// for safety reasons we will check whether the id is available or not and append only when it's not available
        if !tempArray.contains(id) { tempArray.append(id) }
        
        /// save the appended array to user defaults, but remember to delete the purticular id once its been successfully uploaded to firestore
        defaults.set(tempArray, forKey: deletionPendingMyMemoriesIDArrayUserDefaultsKeyName)
        print("Deletion Pending My Memory Item Has Been Added To User Defaults Successfully. ❤️❤️❤️")
        
        /// 4 -  remove the item data document from firestore database
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            /// when things go wrong we will set the deletion in progress property to false unless won't see the list is refreshing ever.
            isDeletionInProgress = false
            return
        }
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "docID": id,
            "myDocID": myUserUID
        ]
        
        functions.httpsCallable("deleteAMemory").call(data) { result, error in
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                /// when things go wrong we will set the deletion in progress property to false unless won't see the list is refreshing ever.
                self.isDeletionInProgress = false
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        /// when things go wrong we will set the deletion in progress property to false unless won't see the list is refreshing ever.
                        self.isDeletionInProgress = false
                        return
                    }
                
                if status {
                    print("🖤🖤🖤 isCompleted: \(status)")
                    
                    /// 5 - once the data has been successfully deleted from the firestore, delete that item's id from the array in user defaults
                    /// get the existing ids array from user defaults
                    var tempArray = self.defaults.stringArray(forKey: self.deletionPendingMyMemoriesIDArrayUserDefaultsKeyName) ?? []
                    
                    /// remove the current id from the temp array
                    tempArray.removeAll(where: { $0 == id })
                    
                    /// once the id has been removed from the temp array, save it back to user defaults
                    self.defaults.set(tempArray, forKey: self.deletionPendingMyMemoriesIDArrayUserDefaultsKeyName)
                    
                    /// once the deletion progress is success, we will set the deletion progress property to false so it will resume refreshing the the my memories list items and its data
                    self.isDeletionInProgress = false
                    print("A My Memory Item Has Been Deleted Successfully. ❤️❤️❤️")
                } else {
                    print("☹️☹️☹️ isCompleted: \(status)")
                    print("Unable To Delete A My Memory Item.🚫🚫🚫")
                    /// when things go wrong we will set the deletion in progress property to false unless won't see the list is refreshing ever.
                    self.isDeletionInProgress = false
                    return
                }
            }
        }
        
        // don't forget to delete all the memory seeners data documents relate to this id
    }
    
    
    // MARK: redeletionMyMemoryListItemFromUserDefaultsNFirestore
    /// sometimes deletion process also can be go wrong. that's why this function comes in handy to delete the items even after if there's something went wrong
    func redeletionMyMemoryListItemFromUserDefaultsNFirestore() {
        
        /// first get the items in the deletion pending ids array from user defaults
        let tempArray: [String] = defaults.stringArray(forKey: deletionPendingMyMemoriesIDArrayUserDefaultsKeyName) ?? []
        
        /// then itterate through items and delete all of em' from both firestore database and user defaults array
        for id in tempArray {
            customDeletionFunction(id: id)
        }
    }
    
    
    // MARK: getMyMemoriesDataFromFirestore
    /// this functions helps to get all the memory seeners data of my memroies by returning the my memories querysnapshot and all the documents ids of my memories
    func getMyMemoriesDataFromFirestore(completion: @escaping (_ status: AsyncFunctionStatusTypes, _ snap: QuerySnapshot?, _ memoryDocIDs: [String]) -> ()) {
        
        var memoriesDataQuerySnapshot: QuerySnapshot?
        var memoryDocIDsArray = [String]()
        
        guard let myUserUID = currentUser.currentUserUID else  {
            print("my user uid nil.")
            completion(.error, memoriesDataQuerySnapshot, [])
            return
        }
        
        db
            .collection("Users/\(myUserUID)/MemoriesData")
            .addSnapshotListener { querySnapshot, error in
                guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty, !self.isDeletionInProgress else {
                    print("either querysnapshot nil or no documents availble.")
                    completion(.error, memoriesDataQuerySnapshot, [])
                    return
                }
                
                print("MemoriesData Snapshot Listner Just Fired 🔥🔥🔥")
                
                /// saves the memories data querysnapshot for later usage within the function
                memoriesDataQuerySnapshot = querySnapshot
                
                ///  store memory doc ids in an array to get memory  seeners data related to them
                for document in querySnapshot.documents {
                    // memory doc id
                    memoryDocIDsArray.append(document.documentID)
                }
                
                completion(.success, memoriesDataQuerySnapshot, memoryDocIDsArray)
            }
    }
    
    
    // MARK: getMemorySeenersDataFromFirestore
    /// this function helps to filter seeners uid to get their profile data later by going through each memory seener data document and also it will return the memoryseeners query snapshot for later usage in another function
    func getMemorySeenersDataFromFirestore(completion: @escaping  (_ status: AsyncFunctionStatusTypes, _ snap: QuerySnapshot?, _ memorySeenersUIDs: [String]) -> ()) {
        
        var memorySeenersDataQuerySnapshot: QuerySnapshot?
        var tempSeenerUIDsArray = [String]()
        
        guard let myUserUID = currentUser.currentUserUID else  {
            print("my user uid nil.")
            completion(.error, memorySeenersDataQuerySnapshot, [])
            return
        }
        
        self.firestoreListener?.remove()
        self.firestoreListener = self.db.collection("Users/\(myUserUID)/MemorySeenersData")
            .order(by: "FullSeenDT", descending: true)
            .addSnapshotListener { querySnapshot, error in
                print("MemorySeenersData Snapshot Listner Just Fired 🔥🔥🔥")
                if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                    /// saves the memory seeners data querysnapshot for later usage within the function
                    memorySeenersDataQuerySnapshot = querySnapshot
                    
                    /// store memory seeners ids in an array to get their basic profile data
                    for document in querySnapshot.documents {
                        
                        if let seenerUID = document.get("SeenerUID") as? String {
                            /// this helps to prevent from id duplication in the array
                            if !tempSeenerUIDsArray.contains(seenerUID) {
                                tempSeenerUIDsArray.append(seenerUID)
                            }
                        }
                    }
                }
                
                completion(.success, memorySeenersDataQuerySnapshot, tempSeenerUIDsArray)
            }
    }
    
    
    // MARK: getMemorySeenersProfileDataFromFirestore
    /// this function will go through all of my memory seeners documents and get their documents and return them out of the function as an array that conforms to 'BasicSeenerProfileData'
    func getMemorySeenersProfileDataFromFirestore(memorySeenersUIDs: [String], completion: @escaping (_ status: AsyncFunctionStatusTypes, _ seenerBasicProfileDataArray: [BasicSeenerProfileDataModel]) -> ()) {
        
        let group = DispatchGroup()
        
        var basicProfileDataArray = [BasicSeenerProfileDataModel]()
        
        for id in memorySeenersUIDs {
            /// we need to use dispatch group, because we are itterating asynchronous functions and it will take a little while to complete
            group.enter()
            db
                .collection("Users/\(id)/ProfileData")
                .document(id)
                .getDocument { documentSnapshot, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        completion(.error, [])
                        return
                    }
                    
                    guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                        print("either document snapshot nil or document not available.")
                        completion(.error, [])
                        return
                    }
                    
                    guard
                        let userName = documentSnapshot.get("UserName") as? String,
                        let profilePhotoThumURL = documentSnapshot.get("ProfilePhotoThumbnail") as? String else {
                            completion(.error, [])
                            return
                        }
                    
                    /// creating an object that conform to 'BasicProfileData', so we can access all the required basic profile data of a seener by one object
                    let object = BasicSeenerProfileDataModel(userUID: id, userName: userName, profilePhotoThumbnailURL: profilePhotoThumURL)
                    
                    /// append the created object to an array that conforms to 'BasicProfileData'
                    basicProfileDataArray.append(object)
                    
                    group.leave()
                }
        }
        
        /// once the itterated asynchronous functions are completed, the following function will excecute
        group.notify(queue: .main) {
            completion(.success, basicProfileDataArray)
        }
    }
    
    
    // MARK: getMyMemoriesDataFromFirestoreNStoreInUserDefaults
    /// this function must excecute everytime user open the app because unless viewers snapshot listener will not be fired
    /// that means we can still see my memories but viewers data won't be updated
    /// that's why we need to call this function every time the user open the app to fire up a snapshot listeners related to getting seeners data
    /// this function retrieve all the data related to my memories in firestore and save them to user defaults so we can get them when ever we want
    func getMyMemoriesDataFromFirestoreNStoreInUserDefaults(completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        /// 1 - first we get all the memories data from firestore
        getMyMemoriesDataFromFirestore { status, myMemoriesDataQuerySnapshot, memoryDocIDs in
            if status == .error {
                completion(.error)
                return
            } else { // succeed and now we have my memories querysnapshot and my memory doc ids
                
                /// 2 - get all memory seeners data documents which are related to my memory doc ids
                self.getMemorySeenersDataFromFirestore { status, memorySeenersDataQuerySnapshot, memorySeenersUIDs in
                    
                    if status == .error {
                        completion(.error)
                        return
                    }  else { // succeed and now we have my memory seeners data querysnapshot and their uids
                        
                        /// 3 - itterate through memory seeners ids array to get ids and get their basic profile data from firestore
                        self.getMemorySeenersProfileDataFromFirestore(memorySeenersUIDs: memorySeenersUIDs) { status, basicSeenerProfileData in
                            
                            if status == .error {
                                completion(.error)
                                return
                            } else { // succeed and now we have my memory seeners profile data as an array of objects that conforms to 'BasicSeenerProfileData'
                                
                                /// 4 - now we can get the exsisting data available in user defaults and remove them all to store the retrieved data from firestore
                                var tempSucceedMyMemoriesDataArray: [MyMemoriesModel] = self.getExistingCustomMyMemoriesDataFromUserDefaults(keyName: self.myMemoriesDataArrayUserDefaultsKeyName)
                                
                                /// usually all the user defauts will be cleared when user logs out
                                /// this whole function excecute when user logs in or reopen the app, and fecth memories data from firestore. so if there's something went wrong while remove data from user defaults when user logs out, the memories data will be there even when the user logs into the app. so that will duplicate memories data.
                                /// to prevent from happening that, we need to remove all the data from the existing my memories data array in  the user defaults
                                tempSucceedMyMemoriesDataArray.removeAll()
                                
                                /// 5 - now it's time to create objects which conform to 'MyMemoriesModel' as we have all the required data for that
                                for document in myMemoriesDataQuerySnapshot!.documents {
                                    
                                    guard
                                        let memoryType = document.get("MemoryType") as? MemoryTypes.RawValue else {
                                            print("error parsing memory type.")
                                            continue
                                        }
                                    
                                    let memoryDocID = document.documentID
                                    let myMemorydata = document.data()
                                    
                                    var tempSeenersDataArray = [SeenersDataModel]()
                                    /// this query snapshot has all the seeners data of all of my memories, so let's map data according to memory ids
                                    /// we don't use else statement for the following 'memorySeenersDataQuerySnapshot' because we can still create my memories without any users
                                    /// we can exit the function because of a problem caused in the 'memorySeenersDataQuerySnapshot', but that's not for the user's experience
                                    /// it's good to display at least something even there's no viewers data available
                                    if let memorySeenersDataQuerySnapshot = memorySeenersDataQuerySnapshot {
                                        for document in memorySeenersDataQuerySnapshot.documents {
                                            
                                            guard
                                                let seenerUID = document.get("SeenerUID") as? String, /// seener's uid
                                                let seenMemoryDocID = document.get("SeenMemoryDocID") as? String else { /// the my memory doc id that seener saw
                                                    continue
                                                }
                                            
                                            let seenersDataDocID = document.documentID /// random doc id of the my memory seener data document
                                            
                                            /// we need to compare whether the my memory doc id that seener saw is equal to one of my memory doc ids
                                            if seenMemoryDocID == memoryDocID {
                                                
                                                let data1 = document.data() /// contains my memory seeners documentd data
                                                
                                                /// here we're trying to map the data related to a purticular seener uid from the 'basicSeenerProfileData' array
                                                if let index = basicSeenerProfileData.firstIndex(where: { $0.userUID == seenerUID }) {
                                                    
                                                    let tempBasicSeenerProfileDataObject = basicSeenerProfileData[index]
                                                    
                                                    let data2: [String:Any] = [
                                                        "SeenerUID": tempBasicSeenerProfileDataObject.userUID,
                                                        "UserName": tempBasicSeenerProfileDataObject.userName,
                                                        "ProfilePhotoThumbnail": tempBasicSeenerProfileDataObject.profilePhotoThumbnailURL
                                                    ]
                                                    
                                                    var mergedDataSet = data1
                                                    
                                                    /// we're merging data to create an object that conforms to 'SeenersDataModel'. we can't create that object in one step because we need to get two types of data from different documents. once we get all the data, we merge them together to create one proper object
                                                    mergedDataSet.merge(data2) {(current, _) in current}
                                                    
                                                    let tempObject2 = SeenersDataModel(docID: seenersDataDocID, data: mergedDataSet)
                                                    
                                                    /// once the seeners data is ready, we'll append it to an array that include all the data related to a seener including my memory doc id that seener saw
                                                    tempSeenersDataArray.append(tempObject2)
                                                } else {
                                                    /// we're trying to get the seeners profile data from the 'basicSeenerProfileData' array, but if something went wrong and no data is available, we have to jump to the next itteration, so we will lose that seener and its data. that's good to jump to the next seener if the current seeners data have some problems internally. at least the user will see some of his seeners even though there's not all the seeners ara availble in the viewers list when checking viewers
                                                    ///  we don't exit from the function even there's something went wrong with the seeners basic profile data array, because that has a negative impact on the user experience. so 'continue' is better than 'return' out of the function
                                                    continue
                                                }
                                            }
                                        }
                                    }
                                    
                                    var object: MyMemoriesModel?
                                    /// we need to convert text based memory to an uimage and then store it in file manager so we can access it as an image when we need to show it to users
                                    if memoryType == "textBased" {
                                        
                                        guard
                                            let text = document.get("Text") as? String,
                                            let colorName = document.get("ColorName") as? String,
                                            let fontName = document.get("FontName") as? String else {
                                                print("error parsing either text, color name or font name")
                                                return
                                            }
                                        
                                        let image: UIImage = MemoriesViewModel.shared.createATextBasedMemoryAsAnUIImage(
                                            text: text,
                                            colorName: colorName,
                                            fontName: fontName
                                        )
                                        
                                        /// we will never compress any of the textbased memories images again because we only does that when retrieving data
                                        /// these compressed data will available in user defaults until user logs out from the device
                                        guard let compressedTextBasedMemoryImageData: Data = image.jpegData(compressionQuality: 1) else {
                                            print("error compressing image data.")
                                            return
                                        }
                                        
                                        object = MyMemoriesModel(
                                            uuid: memoryDocID,
                                            data: myMemorydata,
                                            compressedThumbnailImageData: compressedTextBasedMemoryImageData,
                                            compressedImageData: compressedTextBasedMemoryImageData,
                                            seenersData: tempSeenersDataArray, /// this consist of all the seeners data of a my memory
                                            uploadStatus: .uploaded /// this property is unnecessary at this point, but we have to give it a value as uploaded because that represent this item as a complete memory item in every way.
                                        )
                                    } else { // image based
                                        
                                        /// if the memroy type is image based, we can't create an image at the time of retrieving its url data, because it's a url and not image data
                                        /// so we have to wait until async image view gives us data to create an image
                                        ///  when we are given the data by the async image view, we must not compress it because we are getting data that has been already compressed at the time of uploading the image based memory
                                        ///  we leave the compressed Image data property as nil for now and will create this object again after we are given compressed data from the async image view
                                        ///
                                        ///
                                        /// if we set nil for image data when every time we retrieve data or when snapshot listener fires, all the related user defaults data will be removed and new data will be added.
                                        /// in that case when we try to load image based memory faster with image data, it's not available in the first place because user defaults has been cleared due to new data replacement.
                                        /// what happens is that it will take less than a second or several miliseconds to get the image from cache via web async image framework
                                        /// so when it happens user sees that progress bar while it's loading from cache
                                        /// that has a negative impact when user sees it most of the time
                                        /// it can happen whe user close the app and reopen it again and check the image based memories because when user close the app and reopen it, it will retrieve data from firestore and assign new data to user defaults
                                        /// to avoid this problem we need to make sure to make available all the image based memory data as mush as possible
                                        /// to do that we can check the image data when we retrieve from firestore whether the data exist in user defaults or not
                                        /// if data exists, we can take that data and assign it to compressed image data property as below.
                                        /// when we do that, web async image framework will never excecutes in image based memories scenario and it will always take data as a compressed image data and create a ui image when needed.
                                        /// the goal here is to create an image with compressed image data and reduce using web async image frame as much as possible
                                        
                                        /// it's time to check whether we have the related image data in user defaults in the name of given memory doc id
                                        /// if it's not availble we have to let that take o care of by web async image framework for one time
                                        
                                        
                                        let tempArray: [MyMemoriesModel] = self.getExistingCustomMyMemoriesDataFromUserDefaults(keyName: self.myMemoriesDataArrayUserDefaultsKeyName)
                                        
                                        if let requiredItem = tempArray.first(where: { $0.id == memoryDocID }) {
                                            object = MyMemoriesModel(
                                                uuid: memoryDocID,
                                                data: myMemorydata,
                                                compressedThumbnailImageData: requiredItem.compressedThumbnailImageData,
                                                compressedImageData: requiredItem.compressedImageData,
                                                seenersData: tempSeenersDataArray,
                                                uploadStatus: .uploaded
                                            )
                                            print("Required Image Based Memory Compressed Image Data Available For (\(memoryDocID))💕💕💕")
                                        } else {
                                            object = MyMemoriesModel(
                                                uuid: memoryDocID,
                                                data: myMemorydata,
                                                compressedThumbnailImageData: nil,
                                                compressedImageData: nil,
                                                seenersData: tempSeenersDataArray,
                                                uploadStatus: .uploaded
                                            )
                                            print("Required Image Based Memory Compressed Image Data Not Available For (\(memoryDocID))😤😤😤")
                                        }
                                    }
                                    
                                    guard let object = object else {
                                        print("object nil.")
                                        /// we will exit the function because we can't work with object that are nil.
                                        /// usually it doesn't happen because object becomes nil when it doesn't belongs to either textbsaed or image based memory
                                        ///  i hope this guard statement will never excecute
                                        return
                                    }
                                    
                                    /// once an object is created, we will append it to the 'tempSucceedMyMemoriesDataArray' and once the array is completed, we will save it in the succeed my memories array in user defaults
                                    tempSucceedMyMemoriesDataArray.append(object)
                                }
                                
                                /// 6 - once all the my memory objects have been added to 'tempSucceedMyMemoriesDataArray', we can save it back to user defaults with updated data
                                /// when saving data to user defaults, the function that responsible for saving data to user defaults will remove all the exsisting data before adding new data to it
                                self.saveCustomMemoriesDataArrayToUserDefaults(array: tempSucceedMyMemoriesDataArray, keyName: self.myMemoriesDataArrayUserDefaultsKeyName)
                                print("My Memories Data Has Been Retrieved & Stored in User Defaults Successfully. 🙃🙃🙃")
                                completion(.success)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    // MARK: MY FOLLOWINGS MEMORIES <<--------------------------------------------------------------------------
    
    // MARK: getMyFollowingsMemoriesDataFromUserDefaults
    func getMyFollowingsMemoriesDataFromUserDefaults() {
        
        let tempArray: [[FollowingsMemoriesModel]] = getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: myFollowingsMemoriesDataArrayUserDefaultsKeyName)
        
        DispatchQueue.main.async {
            self.followingsMemoriesDataArray = tempArray.sorted { $0[$0.count-1].fullUploadedDT > $1[$1.count-1].fullUploadedDT }
        }
    }
    
    // MARK: getExistingCustomMyFollowingsMemoriesDataFromUserDefaults
    /// this function will return exsisting data available under given user defaults array of array key name that conforms to 'FollowingsMemoriesModel'
    func getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: String) -> [[FollowingsMemoriesModel]] {
        if let data = defaults.data(forKey: keyName) {
            do {
                let decoder = JSONDecoder()
                
                /// to get data from user defaults as an array of array that conforms to 'FollowingsMemoriesModel', we need to convert that data using json decoder
                let array = try decoder.decode([[FollowingsMemoriesModel]].self, from: data)
                /// once the data is converted to array of array format that conforms to 'FollowingsMemoriesModel', it will be return out of the function
                return array
            } catch {
                print("Unable To Decode.\nError: \(error) 🚫🚫🚫")
                return []
            }
        } else {
            return []
        }
    }
    
    
    // MARK: saveCustomFollowingsMemoriesDataArrayToUserDefaults
    /// this function accepts an array of array that conforms to 'FollowingsMemoriesModel' and store it in user defaults under a given user defsults key name
    func saveCustomFollowingsMemoriesDataArrayToUserDefaults(array: [[FollowingsMemoriesModel]], keyName: String) {
        do {
            let encoder = JSONEncoder()
            
            /// here the given array of array objects will be converted into data using a json encoder to save them in user defaults
            let data = try encoder.encode(array)
            
            ///  once the data is ready, it will be saved in user dafaults under a given name
            defaults.set(data, forKey: keyName)
            print("All Of My Followings Memories Have Been Saved In User Defaults Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
            getMyFollowingsMemoriesDataFromUserDefaults()
        } catch {
            print("Unable To Encode.\nError: \(error) 🚫🚫🚫")
            return
        }
    }
    
    
    // MARK: getFollowingsDataToFilterUIDs
    /// this function will return all of my following user's uids as an array
    /// if any of my followings have been blocked, they will not be added to the array
    func getFollowingsDataToFilterUIDs(completion: @escaping (_ status: AsyncFunctionStatusTypes, _ followingsUIDsArray: [String])-> ()) {
        
        var followingsUIDsArray = [String]()
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(.error, [])
            return
        }
        
        db
            .collection("Users/\(myUserUID)/FollowingsData")
            .whereField("isBlocked", isEqualTo: false)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error, [])
                    return
                } else {
                    
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("either query snapshot nil or no documents available.")
                        completion(.error, [])
                        return
                    }
                    
                    
                    for document in querySnapshot.documents {
                        followingsUIDsArray.append(document.documentID)
                    }
                    
                    print("My Followings UIDs Array Has Been Created Successfully. ❤️❤️❤️")
                    completion(.success, followingsUIDsArray)
                }
            }
    }
    
    
    // MARK: getFollowingsBasicProfileDataFromFirestore
    /// this functio will accept followings ids as an array  and get all the required basic profile data from firestore and return it as an array that conforms to 'BasicFollowingUserProfileData'
    func getFollowingsBasicProfileDataFromFirestore(followingsUIDsArray: [String], completion: @escaping (_ status: AsyncFunctionStatusTypes, _ basicFollowingUserProfileDataArray: [BasicFollowingUserProfileDataModel]) -> ()) {
        
        let group = DispatchGroup()
        
        var basicFollowingUserProfileDataArray = [BasicFollowingUserProfileDataModel]()
        for id in followingsUIDsArray {
            group.enter()
            
            db
                .collection("Users/\(id)/ProfileData")
                .document(id)
                .getDocument { documentSnapshot, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        completion(.error, [])
                        return
                    } else {
                        
                        guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                            print("either document snapshot nil or document doesn't exist.")
                            completion(.error, [])
                            return
                        }
                        
                        guard
                            let userName = documentSnapshot.get("UserName") as? String,
                            let profilePhotoThumbnailURL = documentSnapshot.get("ProfilePhotoThumbnail") as? String,
                            let profession = documentSnapshot.get("Profession") as? String else {
                                print("error parsing document data.")
                                completion(.error, [])
                                return
                            }
                        
                        let tempObject = BasicFollowingUserProfileDataModel(
                            userUID: id,
                            userName: userName,
                            profilePhotoThumbnailURL: profilePhotoThumbnailURL,
                            profession: profession
                        )
                        
                        basicFollowingUserProfileDataArray.append(tempObject)
                        
                        group.leave()
                    }
                }
        }
        
        group.notify(queue: .main) {
            print("Followings Basic Profile Data Has Been Retrieved Successfully. ❤️❤️❤️")
            completion(.success, basicFollowingUserProfileDataArray)
        }
    }
    
    
    // MARK: getFollowingsMemoriesDataFromFirestore
    /// this function excecutes only one time, and that is when user open the app
    /// if you call this function more than once, it will excecutes a lot of snapshot listeners
    func getFollowingsMemoriesDataFromFirestore() {
        
        /// to get followings memories from firestore, first we need to get my followings uids as an array
        getFollowingsDataToFilterUIDs { status, followingsUIDsArray in
            if status == .error {
                print("error getting followings uids array")
                return
            } else {
                /// now we have and can use the followings uids as an array
                /// next we must get their basic profile data conforming to 'BasicFollowingUserProfileData' as an array
                self.getFollowingsBasicProfileDataFromFirestore(followingsUIDsArray: followingsUIDsArray) { status, basicFollowingUserProfileDataArray in
                    if status == .error {
                        print("error getting basic profile data of my followings as an array that conforms to 'BasicFollowingUserProfileData'")
                        return
                    } else {
                        /// now we have and can use my followings uids if needed and their basic profile data that conforms to 'BasicFollowingUserProfileData'
                        /// as now we have their profile data, it's time to get their memories and combine those data with what we have now by also conforming to 'FollowingsMemoriesModel'
                        /// at the end of this else statment, we must store an array of array objects that conforms to 'FollowingsMemoriesModel' to user defaults
                        
                        /// it's time to get my followings memories by itterating through my followings uids array one by one
                        /// we need to add an a firestore snapshot listner for their memories documents because once they made any changes to their memories, we should get it as soon as possible and display on our side
                        for uid in followingsUIDsArray {
                            
                            self.db
                                .collection("Users/\(uid)/MemoriesData")
                                .order(by: "FullUploadedDT")
                                .addSnapshotListener { querySnapshot, error in
                                    print("Followings Memories Data Snapshot Listener Just Fired For (\(uid)) User's Memories 🔥🔥🔥")
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                        /// if there's an error getting their memories, we shouldn't return out of the function as soon as possible, beause we can at least try getting one memories set from at least one following user
                                        /// so, to do that we are not going to return
                                    } else {
                                        if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                                            
                                            var tempAFollowingMemoriesModelArray = [FollowingsMemoriesModel]()
                                            
                                            for document in querySnapshot.documents {
                                                
                                                /// at this point we have:
                                                /// i) a user uid
                                                /// ii) a user profile basic data
                                                /// iii) a memory data from several memories data sets of the user
                                                
                                                /// now it's time to create one object that conforms to 'FollowingsMemoriesModel'
                                                /// but as we are inside a snapshot listener, we need to check whether we have compressed image data availble in user defaults or not
                                                /// if compressed image data is available we're no longer need to download it using a url and that's a waste of data and bad user experience
                                                /// let's check whether we have the compressed image data in user defaults or not
                                                let memoryDocID = document.documentID
                                                let memoryData = document.data()
                                                guard let memoryType = document.get("MemoryType") as? String else {
                                                    print("error parsing the memory type.")
                                                    /// if there's some thing went wrong while parsing the memort type, we'll not return out of the function, but will jump to the next itteration
                                                    /// to do that we use 'continue' keyword
                                                    continue
                                                }
                                                
                                                guard let basicProfileData = basicFollowingUserProfileDataArray.first(where: { $0.userUID == uid }) else {
                                                    print("error getting reuired following user profile basic profile data from 'basicFollowingUserProfileDataArray'")
                                                    /// if something went wrong and unable to get required following user basic profile data, we won't return out of the function because that's bad user experience.
                                                    /// so we jump to the next itteration in followingsUIDsArray
                                                    /// there's no trying to use 'continue', because if the required user's profile basic data is not availble, it will no be availble for the entire memories of that purticular user. so, that's why we break the loop and jump to the next itteration of main loop instead of nested loop
                                                    break
                                                }
                                                
                                                let tempArray: [[FollowingsMemoriesModel]] = self.getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: self.myFollowingsMemoriesDataArrayUserDefaultsKeyName)
                                                
                                                var exsistingFollowingsMemoriesModelItem: FollowingsMemoriesModel?
                                                for item in tempArray {
                                                    if let memoryData = item.first(where: { $0.id == memoryDocID }) {
                                                        exsistingFollowingsMemoriesModelItem = memoryData
                                                    }
                                                }
                                                
                                                var oneMemoryModelObjectOfaFollowingUser: FollowingsMemoriesModel?
                                                if let exsistingFollowingsMemoriesModelItem = exsistingFollowingsMemoriesModelItem {
                                                    oneMemoryModelObjectOfaFollowingUser = FollowingsMemoriesModel(
                                                        memoryDocID: memoryDocID,
                                                        memoriesDocData: memoryData,
                                                        compressedThumbnailImageData: exsistingFollowingsMemoriesModelItem.compressedThumbnailImageData,
                                                        compressedImageData: exsistingFollowingsMemoriesModelItem.compressedImageData,
                                                        followingUserBasicProfileData: basicProfileData,
                                                        isSeen: exsistingFollowingsMemoriesModelItem.isSeen
                                                    )
                                                } else { // required item is not availble in user defaults
                                                    if memoryType == "textBased" {
                                                        guard
                                                            let text = document.get("Text") as? String,
                                                            let colorName = document.get("ColorName") as? String,
                                                            let fontName = document.get("FontName") as? String else {
                                                                /// if there's something wrong while parsing the required properties to create a text based memory image we won't return out of the function but we jump to next itteration by 'continue' keyword
                                                                continue
                                                            }
                                                        
                                                        self.textBasedMemoriesVM.__textEditortext = text
                                                        self.textBasedMemoriesVM.__colorName = colorName
                                                        self.textBasedMemoriesVM.__fontName = fontName
                                                        
                                                        self.textBasedMemoriesVM.onChangeOfTextEditorText()
                                                        
                                                        let textBasedMemoryImage = TextBasedMemoryTextEditorViewAsImage().asImage()
                                                        
                                                        let compressedTextBasedMemoryImageData = textBasedMemoryImage.jpegData(compressionQuality: 1)
                                                        
                                                        oneMemoryModelObjectOfaFollowingUser = FollowingsMemoriesModel(
                                                            memoryDocID: memoryDocID,
                                                            memoriesDocData: memoryData,
                                                            compressedThumbnailImageData: compressedTextBasedMemoryImageData,
                                                            compressedImageData: compressedTextBasedMemoryImageData,
                                                            followingUserBasicProfileData: basicProfileData,
                                                            isSeen: false
                                                        )
                                                    } else { // image based memory
                                                        oneMemoryModelObjectOfaFollowingUser = FollowingsMemoriesModel(
                                                            memoryDocID: memoryDocID,
                                                            memoriesDocData: memoryData,
                                                            compressedThumbnailImageData: nil,
                                                            compressedImageData: nil,
                                                            followingUserBasicProfileData: basicProfileData,
                                                            isSeen: false
                                                        )
                                                    }
                                                }
                                                
                                                /// even if the object is nil for some reason we still don't need to return from the function
                                                /// what we can do is, we can create another object from another memory from the same user
                                                /// in that case we are not using 'break' but 'continue'
                                                guard let oneMemoryModelObjectOfaFollowingUser = oneMemoryModelObjectOfaFollowingUser else {
                                                    continue
                                                }
                                                
                                                /// now we have one memory data item that conform to 'FollowingsMemoriesModel' called 'oneMemoryModelObjectOfaFollowingUser'
                                                tempAFollowingMemoriesModelArray.append(oneMemoryModelObjectOfaFollowingUser)
                                            }
                                            
                                            /// now we have all the memories data set of one following user, and it's called 'tempAFollowingMemoriesModelArray'
                                            print("Memories Data Sets Of (\(uid)) User Has Been Retrieved Successfully. 💕💕💕")
                                            
                                            /// we will get all the memories data of one purticular following users who caused the snapshot listener
                                            /// in that case, we have to get the exsisting followings memories data from user defaults and replace the exsisting object with updated object
                                            var tempArray: [[FollowingsMemoriesModel]] = self.getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: self.myFollowingsMemoriesDataArrayUserDefaultsKeyName)
                                            
                                            if let index = tempArray.firstIndex(where: { $0.contains(where: { $0.userUID == uid }) }) {
                                                tempArray[index] = tempAFollowingMemoriesModelArray
                                                
                                                self.saveCustomFollowingsMemoriesDataArrayToUserDefaults(
                                                    array: tempArray,
                                                    keyName: self.myFollowingsMemoriesDataArrayUserDefaultsKeyName
                                                )
                                                
                                                print("(\(uid)) User's Memory Updates Have Been Updated and Saved Back To User Defaults Successfully. 👍🏻👍🏻👍🏻")
                                            } else {
                                                /// this else statment excecutes when required following user's memories are not available
                                                /// we will append retrieved memories data of that following user to user defaults array that conforms to '[[FollowingsMemoriesModel]]'
                                                var tempArray: [[FollowingsMemoriesModel]] = self.getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: self.myFollowingsMemoriesDataArrayUserDefaultsKeyName)
                                                
                                                tempArray.append(tempAFollowingMemoriesModelArray)
                                                
                                                self.saveCustomFollowingsMemoriesDataArrayToUserDefaults(
                                                    array: tempArray,
                                                    keyName: self.myFollowingsMemoriesDataArrayUserDefaultsKeyName
                                                )
                                            }
                                        } else {
                                            print("either (\(uid)) user has no memories created or querysnapshot nil.")
                                            
                                            /// the following code helps to remove the last memory item of the following user from our side when they delete it from their side.
                                            /// if don't excecute the following, even when the following user deletes all of their memories from their side, we'll have thier last memory in our side as a saved memory item
                                            /// so to avoid happening it, we must excecute the folloowing code  when the program realize there's no more memories items left in their side
                                            var tempArray: [[FollowingsMemoriesModel]] = self.getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: self.myFollowingsMemoriesDataArrayUserDefaultsKeyName)
                                            
                                            tempArray.removeAll(where: { $0.contains(where: { $0.userUID == uid }) })
                                            
                                            self.saveCustomFollowingsMemoriesDataArrayToUserDefaults(
                                                array: tempArray,
                                                keyName: self.myFollowingsMemoriesDataArrayUserDefaultsKeyName
                                            )
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: setFollowingsMemorySeenFlagInFirestoreNUserDefaults
    func setFollowingsMemorySeenFlagInFirestoreNUserDefaults(memorySeenerModelObject: MemorySeenerModel) {
        /// as now we have the some required data, we need to create the following properties properly to create a document in firestore by envoking a cloud function
        
        /// seenMemoryDocID
        /// fullSeenDT
        /// seenDate
        /// seenTime
        /// seenerUID
        
        lazy var functions = Functions.functions()
        
        let data: [String: Any] = [
            "seenMemoryDocID": memorySeenerModelObject.id,
            "fullSeenDT": memorySeenerModelObject.fullSeenDT,
            "seenDate": memorySeenerModelObject.seenDate,
            "seenTime": memorySeenerModelObject.seenTime,
            "seenerUID": memorySeenerModelObject.seenerUID,
            "followingUserUID": memorySeenerModelObject.followingUserUID
        ]
        
        let object = MemorySeenerModel(data: data)
        
        functions.httpsCallable("setSeenFlagForAFollowingsMemory").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                self.saveFailedFollowingsMemoriesSeenFlagsDataToUserDefaults(failedDataObject: object)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        print("error parsing response status.")
                        self.saveFailedFollowingsMemoriesSeenFlagsDataToUserDefaults(failedDataObject: object)
                        return
                    }
                if status {
                    print("🖤🖤🖤 isCompleted: \(status)")
                    print("(\(memorySeenerModelObject.id) Following User's Memory Item Has Been Flagged As Seen Successfully. ❤️❤️❤️")
                    
                    self.setFollowingsMemoriesSeenFlagToTrueLocally(memoryDocID: memorySeenerModelObject.id)
                    self.removeACustomFailedFollowingsMemoriesSeenFlagsDataFromUserDefaults(memoryDocID: memorySeenerModelObject.id)
                } else {
                    print("☹️☹️☹️ isCompleted: \(status)")
                    print("Unable To Set Flag For The (\(memorySeenerModelObject.id) Following User's Memory Item.🚫🚫🚫")
                    self.saveFailedFollowingsMemoriesSeenFlagsDataToUserDefaults(failedDataObject: object)
                }
            }
        }
    }
    
    
    // MARK: setFollowingsMemoriesSeenFlagToTrueLocally
    func setFollowingsMemoriesSeenFlagToTrueLocally(memoryDocID: String) {
        var tempArray: [[FollowingsMemoriesModel]] = getExistingCustomMyFollowingsMemoriesDataFromUserDefaults(keyName: myFollowingsMemoriesDataArrayUserDefaultsKeyName)
        
        if let index1 = tempArray.firstIndex(where: { $0.contains(where: { $0.id == memoryDocID }) }) {
            if let index2 = tempArray[index1].firstIndex(where: { $0.id == memoryDocID }) {
                tempArray[index1][index2].isSeen = true
                
                saveCustomFollowingsMemoriesDataArrayToUserDefaults(array: tempArray, keyName: myFollowingsMemoriesDataArrayUserDefaultsKeyName)
            }
        }
    }
    
    
    // MARK: saveFailedFollowingsMemoriesSeenFlagsDataToUserDefaults
    func saveFailedFollowingsMemoriesSeenFlagsDataToUserDefaults(failedDataObject: MemorySeenerModel) {
        
        /// to save the failed data object to user defaults, we need to get the exsisting failed objects array from user defaults, and then we can append the current object to that array and save it to user defaults
        var tempArray: [MemorySeenerModel] = getExsistingFailedFollowingsMemoriesSeenFlagsDataFromUserDefaults()
        
        /// now we can append the current object to the 'tempArray'
        /// but before doing that we need need to make sure there's no any exsisting object available in the 'tempArray' that has the same memory doc id
        /// if we append without checking, there could be object duplications
        if !tempArray.contains(where: { $0.id == failedDataObject.id }) {
            /// we can safly append the current object to the 'tempArray', and there will not be any object duplications after this
            tempArray.append(failedDataObject)
            
            /// once the object is appended safely, we can convert that array of objects into data to save it to user defaults
            do {
                let encoder = JSONEncoder()
                
                let data = try encoder.encode(tempArray)
                
                /// once the array has been encoded to data, it will be saved in related array in user defaults
                defaults.set(data, forKey: failedMemorySeenFlagsUserDefaultsKeyName)
                print("A Purticular Failed Seen Flag Memory Object Has Been Saved In User Defaults Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
            } catch {
                print("Unable To Encode.\nError: \(error) 🚫🚫🚫")
                return
            }
        }
    }
    
    
    // MARK: saveFailedFollowingsMemoriesSeenFlagsDataToUserDefaults
    func saveFailedFollowingsMemoriesSeenFlagsDataToUserDefaults(failedDataObjectsArray: [MemorySeenerModel]) {
        
        do {
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(failedDataObjectsArray)
            
            /// once the array has been encoded to data, it will be saved in related array in user defaults
            defaults.set(data, forKey: failedMemorySeenFlagsUserDefaultsKeyName)
            print("A Purticular Failed Seen Flag Memory Object Has Been Saved In User Defaults Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
        } catch {
            print("Unable To Encode.\nError: \(error) 🚫🚫🚫")
            return
        }
    }
    
    
    // MARK: getExsistingFailedFollowingsMemoriesSeenFlagsDataFromUserDefaults
    func getExsistingFailedFollowingsMemoriesSeenFlagsDataFromUserDefaults() -> [MemorySeenerModel] {
        
        /// first we will get the data from user defaults in data fromat, and then convert those data into an array of objects that conforms to 'MemorySeenerModel' with the help of json decorder
        guard let data = defaults.data(forKey: failedMemorySeenFlagsUserDefaultsKeyName) else {
            return []
        }
        
        /// once we got the data from user defaults, we can decode it
        do {
            /// we need json decoder to decode encoded data into an array of objects
            let decoder = JSONDecoder()
            
            /// data will be decoded into an array of objects that conforms to 'MyMemoriesModel'
            return try decoder.decode([MemorySeenerModel].self, from: data)
        } catch {
            print("Unable To Decode.\nError: \(error) 🚫🚫🚫")
            return []
        }
    }
    
    
    // MARK: removeACustomFailedFollowingsMemoriesSeenFlagsDataFromUserDefaults
    func removeACustomFailedFollowingsMemoriesSeenFlagsDataFromUserDefaults(memoryDocID: String) {
        
        /// to remove a failed following memory seen flag item, we need to get the exsisting data from user defaults, and then remove the required item from it and save it back to user defaults
        /// let's get the exsisting data first
        var tempArray: [MemorySeenerModel] = getExsistingFailedFollowingsMemoriesSeenFlagsDataFromUserDefaults()
        
        /// now we can remove the reuired item from the 'tempArray'
        tempArray.removeAll(where: { $0.id == memoryDocID })
        
        /// once the required item is deleted from the 'tempArray', we must save the rest of the data backto user defaults
        saveFailedFollowingsMemoriesSeenFlagsDataToUserDefaults(failedDataObjectsArray: tempArray)
    }
    
    
    // MARK: reuploadFailedFollowingsMemorySeenFlagInFirestoreNUserDefaults
    func reuploadFailedFollowingsMemorySeenFlagInFirestoreNStoreInUserDefaults() {
        
        /// to reupload failed followings memories seen flag item to firestore, we need to call this function time to time
        /// we need to get the failed items from user defaults first
        let tempArray: [MemorySeenerModel] = getExsistingFailedFollowingsMemoriesSeenFlagsDataFromUserDefaults()
        
        /// now we need to iterate through the 'tempArray' to get each item one by one and reupload to firestore using 'setFollowingsMemorySeenFlagInFirestoreNUserDefaults()' function
        for item in tempArray {
            setFollowingsMemorySeenFlagInFirestoreNUserDefaults(memorySeenerModelObject: item)
        }
    }
    
    
    // MARK: filterResults
    private func filterResults(searchText: String) {
        if(searchText.isEmpty) {
            filteredFollowingsMemoriesDataArray = followingsMemoriesDataArray
        } else {
            filteredFollowingsMemoriesDataArray = followingsMemoriesDataArray.filter { $0.contains(where: {
                $0.userName.localizedCaseInsensitiveContains(searchText) || $0.profession.localizedCaseInsensitiveContains(searchText)
            }) }
        }
    }
}
