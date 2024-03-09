//
//  MessageSheetViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-05.
//

import Foundation
import Firebase

class MessageSheetViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = MessageSheetViewModel()
    
    // referennce to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to firestore
    let db = Firestore.firestore()
    
    // reference to User Defaults
    let defaults = UserDefaults.standard
    
    // a firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    // this variable stores all of my chat data by conforming to [[MessageSheetContentModel]]
    @Published var AllOfMyChatDataArray = [MessageSheetContentModel]()
    
    // a user defaults key name to store all of my chat data to an array in user defaults
    let myChatDataUserDefaultsKeyName: String = "MyChatData"
    
    // a timer that helps to resend pending messages
    let pendingMessagesReuploaderTimer = Timer.publish(every: 5, tolerance: 5, on: .main, in: .common).autoconnect()
    
    // a timer that take chat data from user defaults every 1 second and assign it to 'AllOfMyChatDataArray'
    let getNAssignChatDataFromUserDefaultsTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // an array that stores flaged messages chatDocIDs temporarily
    @Published var messageFlagRegisterArray = [String]()
    
    // show or hide blur effect with reaction emojies buttons view
    @Published var startAnimation: Bool = false
    
    // an array that stores all the happening IDs along with the isTyping flag of my chat data
    @Published var isTypingDataArray = [UserIsTypingModel]()
    
    
    // MARK: FUNCTIONS
    
    
    // MARK: getMessagesFromUserDefaults
    /// this function should run every 1 second to update any chat view
    /// because all the messages will be directly saved to the user defaults, not to an array
    /// in that case even if there's any updates on any chat, it will be really update theough this function
    /// a timer should call this function every 1 second using a timer and assign all the data to the 'AllOfMyChatDataArray'
    /// from there on, a purticular view will filter related chat data from the 'AllOfMyChatDataArray'
    func getMessagesFromUserDefaults() -> [MessageSheetContentModel] {
        
        /// first we will get the data from user defaults in data fromat, and then convert those data into an array of objects that conforms to 'MessageSheetContentModel' with the help of json decorder
        guard let data = defaults.data(forKey: myChatDataUserDefaultsKeyName) else {
            return []
        }
        
        /// once we got the data from user defaults, we can decode it
        do {
            /// we need a json decoder  to decode encoded data
            let decoder = JSONDecoder()
            /// now we can decode data into an array of objects using json decoder
            let array = try decoder.decode([MessageSheetContentModel].self, from: data)
            /// once the data has been decoded to an array of objects, we can retun them out if the function
            return array
        } catch {
            print("Unable To Decode.\nError: \(error) 🚫🚫🚫")
            /// if there's an error while decodeing data into an array of objects, we will return a nil array of objects
            return []
        }
    }
    
    
    // MARK: saveMessagesArrayToUserDefaults
    func saveMessagesArrayToUserDefaults(array: [MessageSheetContentModel]) {
        
        var tempArray: [MessageSheetContentModel] = getMessagesFromUserDefaults()
        
        for item in array {
            tempArray.removeAll(where: { $0.happeningDocID == item.happeningDocID })
        }
        
        tempArray += array
        
        do {
            /// we need a json encorder  to encode array data
            let encoder = JSONEncoder()
            
            /// encoding array of objects to data using json encoder
            let data = try encoder.encode(tempArray)
            
            /// save rest of the array data back to user defaults
            defaults.set(data, forKey: myChatDataUserDefaultsKeyName)
            AllOfMyChatDataArray = getMessagesFromUserDefaults()
            print("All Of My Chat Data Has Been Saved In User Defaults Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
        } catch {
            print("Unable To Encode.\nError: \(error) 🚫🚫🚫")
            return
        }
    }
    
    
    // MARK: createAPendingMessage
    func createAPendingMessage(object: MessageSheetContentModel) {
        
        /// here we will receive an object that has an assigned 'false' value to the 'isSent' property.
        /// we should safely append the object to the user defaults
        /// first we will get the exsisting data from user defaults
        var tempArray: [MessageSheetContentModel] = getMessagesFromUserDefaults()
        
        /// now we need to check whether a message related to same 'chatDocID' is available or not
        /// we will only append the current object if there's no same 'chatDocID' exsist
        if !tempArray.contains(where: { $0.chatDocID == object.chatDocID }) {
            tempArray.append(object)
            /// once we successfully add the object to tempArray, we can save it back to user defaults
            saveMessagesArrayToUserDefaults(array: tempArray)
            print("A Pending Message Has Been Created Successfully. ❤️❤️❤️")
        }
    }
    
    
    // MARK: updateAPendingMessage
    func updateAPendingMessageAsSent(chatDocID: String) {
        
        /// first we have to get all of the exsisting chat data from user defaults
        var tempArray: [MessageSheetContentModel] = getMessagesFromUserDefaults()
        
        /// once we got the chat data array, we can look for the exact chat data object where 'chatDocID' matches with the given 'chatDocID'
        if let index = tempArray.firstIndex(where: { $0.chatDocID == chatDocID }) {
            /// once we found the index, we can change the 'isSent' property to 'true' as it has been sent successfully.
            tempArray[index].isSent = true
            /// once we update the property in the tempArray, we need to save it back to userdefaults.
            saveMessagesArrayToUserDefaults(array: tempArray)
            print("A Pending Message Has Been Sent Successfully. 👍🏻👍🏻👍🏻")
        } else {
            print("Error Getting Chat Data Object Related To Given ChatDocID 😢😢😢")
        }
    }
    
    
    //  MARK: SendAMessage
    func sendAMessage(happeningDocID: String, happeningTitle: String, receiverUID: String, msgText: String, pendingChatDocID: String?, pendingSentTime: String?, pendingSentTimeFull: String?, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        guard let myUserUID = CurrentUser.shared.currentUserUID else {
            print("my user uid nil.")
            completion(.error)
            return
        }
        
        /// we will create a unique id for the current message and that will be assigned as 'chatDocID'
        var chatDocID = UUID().uuidString
        
        var sentTime: String = getCurrentDateAndTime(format: "h:mm a")
        var sentTimeFull: String = getCurrentDateAndTime(format: "yyyy-MM-dd HH:mm:ss")
        
        if let pendingChatDocID = pendingChatDocID {
            chatDocID = pendingChatDocID
        }
        
        if
            let pendingSentTime = pendingSentTime,
            let pendingSentTimeFull = pendingSentTimeFull {
            
            sentTime = pendingSentTime
            sentTimeFull = pendingSentTimeFull
        }
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "chatDocID": chatDocID,
            "happeningDocID": happeningDocID,
            "happeningTitle": happeningTitle,
            "senderUID": myUserUID,
            "receiverUID": receiverUID,
            "msgText": msgText,
            "sentTime": sentTime,
            "sentTimeFull": sentTimeFull
        ]
        
        let pendingMsgObject = MessageSheetContentModel(data: [
            "HappeningDocID": happeningDocID,
            "HappeningTitle": happeningTitle,
            "SenderUID": myUserUID,
            "ReceiverUID": receiverUID,
            "MsgText": msgText,
            "ChatDocID": chatDocID,
            "isSent": false,
            "isDelivered": false,
            "isRead": false,
            "SentTime": sentTime,
            "SentTimeFull": sentTimeFull
        ])
        
        createAPendingMessage(object: pendingMsgObject)
        
        functions.httpsCallable("sendAMessage").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                completion(.error)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        return
                    }
                if status {
                    print("🖤🖤🖤 isCompleted: \(status)")
                    print("('\(msgText)') Message Has Been Sent Successfully. ❤️❤️❤️")
                    
                    /// once the message has been sent successfully, we need to update the 'isSent' property of this perticular message to 'true'
                    self.updateAPendingMessageAsSent(chatDocID: chatDocID)
                    completion(.success)
                } else {
                    print("☹️☹️☹️ isCompleted: \(status)")
                    print("Unable To Send The ('\(msgText)') Message.🚫🚫🚫")
                    completion(.error)
                }
            }
        }
    }
    
    
    // MARK: pendingMessagesResender
    /// this function should be called every 5 seconds using a timer
    func pendingMessagesResender() {
        
        guard let myUserUID = currentUser.currentUserUID else {
            return
        }
        
        /// first we need to get all of the exsisting chat data from user defaults
        let tempArray: [MessageSheetContentModel] = getMessagesFromUserDefaults()
        
        /// now we need to filter all the chats where its 'isSent' property is equal to 'false' and add them to a temporary pending chat data array
        /// then we can itterate through the temporary array to resent them to  firestore database
        let tempPendingChatDataArray = tempArray.filter { $0.isSent == false && $0.senderUID == myUserUID }
        
        for object in tempPendingChatDataArray {
            sendAMessage(
                happeningDocID: object.happeningDocID,
                happeningTitle: object.happeningTitle,
                receiverUID: object.receiverUID,
                msgText: object.msgText,
                pendingChatDocID: object.chatDocID,
                pendingSentTime: object.sentTime,
                pendingSentTimeFull: object.sentTimeFull) { _ in }
        }
    }
    
    
    // MARK: getChatDataFromFirestore
    func getChatDataFromFirestore(happeningDocID: String, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            completion(.error)
            return
        }
        
        firestoreListener?.remove()
        firestoreListener = db
            .collection("Users/\(myUserUID)/ChatData")
            .whereField("HappeningDocID", isEqualTo: happeningDocID)
            .order(by: "SentTimeFull")
            .addSnapshotListener { querySnapshot, error in
                print("SnapshotListener just fired!... 🔥🔥🔥")
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error)
                    return
                } else {
                    guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                        print("query snapshot nil or no documents available.")
                        
                        var tempArray: [MessageSheetContentModel] = self.getMessagesFromUserDefaults()
                        tempArray.removeAll(where: { $0.happeningDocID == happeningDocID })
                        self.saveMessagesArrayToUserDefaults(array: tempArray)
                        
                        return
                    }
                    
                    /// once we got the query snapshot, we must replace all the chat data related to the purticular 'happeningDocID'  in user defaults chat data array
                    var tempObjectsArray = [MessageSheetContentModel]()
                    for document in querySnapshot.documents {
                        let data = document.data()
                        let object: MessageSheetContentModel = MessageSheetContentModel(data: data)
                        
                        tempObjectsArray.append(object)
                    }
                    
                    /// now we have all the chat data object related to a purticular happening doc id
                    /// now we should get the exsisting chat data from user defaults to to any changes
                    var tempArray: [MessageSheetContentModel] = self.getMessagesFromUserDefaults()
                    
                    /// now we should delete all the chat data related to the above happening doc ID from temp array
                    tempArray.removeAll(where: { $0.happeningDocID == happeningDocID })
                    
                    /// once we deleted all the chat data related to the above happening doc id, we can assign the downloaded chat data to the temp array
                    for object in tempObjectsArray {
                        tempArray.append(object)
                        
                        if object.senderUID != myUserUID && !object.isUpdated && !self.messageFlagRegisterArray.contains(object.chatDocID){
                            self.messageFlagRegisterArray.append(object.chatDocID)
                            
                            self.setMessageFlags(
                                chatDocID: object.chatDocID,
                                creatorsUID: object.senderUID,
                                flagType: .isDelivered) { _ in }
                        }
                    }
                    /// once the for loop finishes, we have added all the new data related to a happening doc id
                    /// now we should save the temp array back to user defaults
                    self.saveMessagesArrayToUserDefaults(array: tempArray)
                    print("Chat Data Related To (\(happeningDocID)) Happening Doc ID Has Been Retrieved Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                    completion(.success)
                }
            }
    }
    
    
    // MARK: setMessageFlags
    func setMessageFlags(chatDocID: String, creatorsUID: String, flagType: MessageFlagTypes, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("Error: my user uid nil.")
            completion(.error)
            return
        }
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "chatDocID": chatDocID,
            "creatorsUID": creatorsUID,
            "myUserUID": myUserUID,
            "isRead": flagType == .isRead ? true : false
        ]
        
        functions.httpsCallable("flagAMessage").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                completion(.error)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        return
                    }
                if status {
                    print("🖤🖤🖤 isCompleted: \(status)")
                    print("Message Has Been Flaged To '\(flagType)' Successfully. ❤️❤️❤️")
                    completion(.success)
                } else {
                    print("☹️☹️☹️ isCompleted: \(status)")
                    print("Unable To Flag The Message.🚫🚫🚫")
                    completion(.error)
                }
            }
        }
    }
    
    
    // MARK: updateMessageReactionInUserDefaultsNFirestore
    func updateMessageReactionInUserDefaults(reaction: ReactorEmojiTypes, item: MessageSheetContentModel, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        var tempArray: [MessageSheetContentModel] = getMessagesFromUserDefaults()
        
        print("happening Doc ID: \(item.happeningDocID)")
        print("chatDocID: \(item.chatDocID)")
        
        
        print("\n\(tempArray.map { $0.msgText } as Any)")
        
        
        if let index = tempArray.firstIndex(where: { $0.happeningDocID == item.happeningDocID && $0.chatDocID == item.chatDocID }) {
            tempArray[index].reactionString = reaction.rawValue
            
            saveMessagesArrayToUserDefaults(array: tempArray)
            print("Reaction Has Been Updated In User Defaults Successfully. ❤️❤️❤️")
            
            updateMessageReactionInFirestore(reaction: reaction, item: item) { _ in }
        } else {
            print("The Required Index Not Found. 😢😢😢")
            vibrate(type: .error)
            completion(.error)
        }
    }
    
    
    // MARK: updateMessageReactionInFirestore
    func updateMessageReactionInFirestore(reaction: ReactorEmojiTypes, item: MessageSheetContentModel, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        lazy var functions = Functions.functions()
        
        let data:[String: Any] = [
            "happeningDocID": item.happeningDocID,
            "chatDocID": item.chatDocID,
            "user1UID": item.senderUID,
            "user2UID": item.receiverUID,
            "reaction": reaction.rawValue
        ]
        
        functions.httpsCallable("updateAMessageReaction").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                completion(.error)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        return
                    }
                if status {
                    print("🖤🖤🖤 isCompleted: \(status)")
                    print("Message Reaction Has Been Updated Successfully. ❤️❤️❤️")
                    completion(.success)
                } else {
                    print("☹️☹️☹️ isCompleted: \(status)")
                    print("Unable To Update The Message Reaction.🚫🚫🚫")
                    completion(.error)
                }
            }
        }
    }
    
    
    // MARK: setIsTypingMessageFlag
    func setIsTypingMessageFlag(happeningDocID: String, user2UID: String, isTyping: Bool, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("Error: my user uid nil.")
            completion(.error)
            return
        }
        
        let data: [String: Any] = [
            "happeningDocID": happeningDocID,
            "typingUserUID": myUserUID,
            "myUserUID": user2UID,
            "isTyping": isTyping
        ]
        
        lazy var functions = Functions.functions()
        
        functions.httpsCallable("updateIsTypingFlag").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                completion(.error)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        return
                    }
                if status {
                    print("🖤🖤🖤 isCompleted: \(status)")
                    completion(.success)
                } else {
                    print("☹️☹️☹️ isCompleted: \(status)")
                    completion(.error)
                }
            }
        }
    }
    
    
    // MARK: getIsTypingChatDataFromFirestore
    func getIsTypingChatDataFromFirestore(completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        db
            .collection("TypingChatData")
            .addSnapshotListener { querySnapshot, error in
                print("Typing Chat Data Flag Snapshot Listener Just Fired! 🔥🔥🔥")
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error)
                    return
                } else {
                    guard let querySnapshot = querySnapshot else {
                        print("either qurey snapshot nil or no documents availble.")
                        completion(.error)
                        return
                    }
                    
                    self.isTypingDataArray.removeAll()
                    
                    for document in querySnapshot.documents {
                        let data = document.data()
                        
                        let object = UserIsTypingModel(data: data)
                        
                        self.isTypingDataArray.append(object)
                    }
                    
                    print("All The 'IsTypingChatData' Documents Have Been Retrieved Successfully. 👍🏻👍🏻👍🏻")
                    completion(.success)
                }
            }
    }
}
