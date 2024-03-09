//
//  CreateAHappeningViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-06.
//

import Foundation
import UIKit
import SwiftUI
import Firebase

class CreateAHappeningViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = CreateAHappeningViewModel()
    
    // reference to firestore database
    let db = Firestore.firestore()
    
    // reference to CurrentUser class
    let currentUser =  CurrentUser.shared
    
    // controls the happening titile text field value
    @Published var happeningTitleTextFieldText: String = ""
    
    // controls the character count of the happening title text
    @Published var happeningTitleCharactersCount: Int = 30
    
    // controls nuber of spaces a happening can have
    @Published var noOfSpaces: Int = 1
    
    // controls the happening address
    @Published var happeningAddressTextFieldText: String = ""
    
    // controls the space fee for the happening
    @Published var spaceFeeTextFieldtext: String = ""
    
    // controls the currency of the region that the user is in
    @Published var currency: String = Locale.current.currencyCode ?? ""
    
    // controls the description of the happening
    @Published var happeningDescriptionTextEditorText: String = ""
    
    @Published var happeningDescriptionTextEditorTextLimit: Int = 300
    
    @Published var happeningDescriptionTextEditorTextLimitColor: Color = .primary
    
    // present a sheet that contains a map viewthat decide the happening location
    @Published var isPresentedSheetForMapView: Bool = false
    
    // present an alert item for CreateAHappeningView
    @Published var alertItemForCreateAHappeningView: AlertItemModel?
    
    // present an alert item for MyHappeningLocationMapView
    @Published var alertItemForMyHappeningLocationMapView: AlertItemModel?
    
    // controls the selected image for the tab view (image slide show)
    @Published var selectedImage: Int = 0
    
    // stores the happening photos in this array
    @Published var happeningPhotosArray: [UIImage] = [UIImage]() {
        didSet {
            createAHappeningValidation()
            // once the 5 photos are added, the add photo button will be disabled
            if(happeningPhotosArray.count == 5) {
                isDisabledAddaPhotoButton = true
            } else {
                isDisabledAddaPhotoButton = false
            }
        }
    }
    
    // present a confiramation dialog when user click on add a photo button
    @Published var isPresentedAddaPhotoConfirmationDialog: Bool = false
    
    // present the photo library inthe image picker
    @Published var isPresentedPhotoLibrary: Bool = false
    
    // present the camera in the image picker
    @Published var isPresentedCameraSheet: Bool = false
    
    // present a full cover sheet for the image picker
    @Published var isPresentedAddaPhotoFullCoverSheet: Bool = false
    
    // image picker selection options
    enum PickerSelection {
        case photo
        case camera
    }
    
    // controls the selected image from the image picker
    @Published var selectedOrTakenPhoto: UIImage? {
        didSet {
            guard
                let image =  selectedOrTakenPhoto,
                let imageData = image.jpegData(compressionQuality: 1) else { return }
            
            // take the image size from the selected image in the image picker
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            let string = bcf.string(fromByteCount: Int64(imageData.count))
            let imageSize =  (string as NSString).floatValue
            print("Image Size: \(string)")
            
            // if the selected image is more than 5 mega bytes, an alert will be presented. if not the image will be added to the photo array
            if(imageSize > 5) {
                alertItemForHappeningPhotoList = AlertItemModel(title: "Image Over 5 MB", message: "Image file must not exceed 5MB.")
                selectedOrTakenPhoto = nil
            } else {
                happeningPhotosArray.append(image)
                print("Happening Photo Array Count: \(happeningPhotosArray.count)")
            }
        }
    }
    
    // controls the disability of the add a photo button
    @Published var isDisabledAddaPhotoButton: Bool = false
    
    // present an error alert if something goes wrong while picking an image form the image picker
    @Published var isPresentedAlertForImageError: Bool = false
    
    // state whether the image is added or not from the image picker
    @Published var isImageAddedSuccessful: Bool = false {
        didSet {
            createAHappeningValidation()
        }
    }
    
    // present an alert item for the happening photo list
    @Published var alertItemForHappeningPhotoList: AlertItemModel?
    
    // standard dates for sorting purposes
    @Published var standardStartingDT: String = ""
    @Published var standardEndingDT: String = ""
    
    // controls the starting date selection
    @Published var startingDateTimeSelection: Date = Date() {
        didSet {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E d MMM @ h:mm a"
            let formattedDate = formatter.string(from: startingDateTimeSelection)
            
            let formatter2 = DateFormatter()
            formatter2.locale = Locale(identifier: "en_US_POSIX")
            formatter2.dateFormat = "yyyy-MM-dd HH:mm"
            let formattedDate2 = formatter2.string(from: startingDateTimeSelection)
            
            selectedStartingDT = formattedDate
            standardStartingDT = formattedDate2
        }
    }
    
    
    // controls the ending date selection
    @Published var endingDateTimeSelection: Date = Date() {
        didSet {
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "E d MMM @ h:mm a"
            let formattedDate1 = formatter1.string(from: endingDateTimeSelection)
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "E d MMM"
            let formattedDate2 = formatter2.string(from: startingDateTimeSelection)
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "E d MMM"
            let formattedDate3 = formatter3.string(from: endingDateTimeSelection)
            
            let formatter4 = DateFormatter()
            formatter4.dateFormat = "h:mm a"
            let formattedDate4 = formatter4.string(from: endingDateTimeSelection)
            
            if(formattedDate2 == formattedDate3) {
                selectedEndingDT = formattedDate4
            } else {
                selectedEndingDT = formattedDate1
            }
            
            let formatter5 = DateFormatter()
            formatter5.locale = Locale(identifier: "en_US_POSIX")
            formatter5.dateFormat = "yyyy-MM-dd HH:mm"
            let formattedDate5 = formatter5.string(from: endingDateTimeSelection)
            
            standardEndingDT = formattedDate5
        }
    }
    
    // controls the formatted starting date and time
    @Published var selectedStartingDT: String = ""
    
    // controls the formatted ending date and time
    @Published var selectedEndingDT: String = ""
    
    // controls the starting day
    let startingDate: Date = Date()
    
    // controls the starting day range
    let startingEndingDate: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    
    // controls the SetLocation status in the create a Happening view
    @Published var setLocationStatus: setLocationStatus = .notSet {
        didSet {
            createAHappeningValidation()
        }
    }
    
    // option types for set location status
    enum setLocationStatus: String {
        case notSet = "Not Yet Set"
        case set = "Done"
    }
    
    // controls the type of the space fee
    @Published var selectedSpaceFeeType: SpaceFeeType = .Free
    
    // controls the diability of the create button in the create a happening view
    @Published var isDisabledCreateButton: Bool = true
    
    // controls the disability of the create a happening list view
    @Published var isDisabledCreateAHappeningView: Bool = false
    
    // present a progress status text view while calling createAHappening cloud function
    @Published var isPresentedCreatingProgress: Bool = false
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: openPhotoOrCameraPicker
    func openPhotoOrCameraPicker(selction: PickerSelection) {
        
        if(selction == .photo) {
            isPresentedCameraSheet = false
            isPresentedPhotoLibrary = true
        } else {
            isPresentedPhotoLibrary = false
            isPresentedCameraSheet = true
        }
        
        isPresentedAddaPhotoFullCoverSheet = true
    }
    
    // MARK: deleteHappeningPhotoListItem
    func deleteHappeningPhotoListItem(indexSet: IndexSet) {
        happeningPhotosArray.remove(atOffsets: indexSet)
    }
    
    // MARK: moveHappeningPhotoListItem
    func moveHappeningPhotoListItem(from: IndexSet, to: Int) {
        happeningPhotosArray.move(fromOffsets: from, toOffset: to)
    }
    
    // MARK: limitHappeningTitleText
    func limitHappeningTitleText() {
        if (happeningTitleTextFieldText.count > happeningTitleCharactersCount) {
            happeningTitleTextFieldText = String(happeningTitleTextFieldText.prefix(happeningTitleCharactersCount))
            
            alertItemForCreateAHappeningView = AlertItemModel(
                title: "Character Limit Exceeded",
                message: "Only \(happeningTitleCharactersCount) characters are allowed.\nTry to keep it simple and meaningful."
            )
        }
    }
    
    // MARK: limitHappeningDescriptionText
    func limitHappeningDescriptionText() {
        if (happeningDescriptionTextEditorText.count > happeningDescriptionTextEditorTextLimit) {
            happeningDescriptionTextEditorText = String(happeningDescriptionTextEditorText.prefix(happeningDescriptionTextEditorTextLimit))
        }
        
        if(happeningDescriptionTextEditorText.count == happeningDescriptionTextEditorTextLimit) {
            happeningDescriptionTextEditorTextLimitColor = .red
        }
        else{
            happeningDescriptionTextEditorTextLimitColor = .primary
        }
    }
    
    // MARK: createAHappeningValidation
    func createAHappeningValidation() {
        
        var titleCheck: Bool = false
        var photosCheck: Bool =  false
        var descriptionCheck: Bool = false
        var startingDateCheck: Bool = false
        var endingDateCheck: Bool =  false
        var locationCheck: Bool = false
        var addressCheck: Bool = false
        var feeCheck: Bool = true
        
        if(happeningTitleTextFieldText.count >= 10) {
            titleCheck = true
        } else {
            titleCheck = false
        }
        
        if(!happeningPhotosArray.isEmpty) {
            photosCheck = true
        } else {
            photosCheck = false
        }
        
        if(happeningDescriptionTextEditorText.count >= 10) {
            descriptionCheck = true
        } else {
            descriptionCheck = false
        }
        
        if(startingDateTimeSelection > Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date()) {
            startingDateCheck = true
        } else {
            startingDateCheck = false
        }
        
        if(endingDateTimeSelection > Calendar.current.date(byAdding: .minute, value: 15, to: startingDateTimeSelection) ?? Date()) {
            endingDateCheck = true
        } else {
            endingDateCheck = false
        }
        
        if(self.setLocationStatus == .set) {
            locationCheck = true
        } else {
            locationCheck = false
        }
        
        if(happeningAddressTextFieldText.count >= 10) {
            addressCheck = true
        } else {
            addressCheck = false
        }
        
        if(!spaceFeeTextFieldtext.isEmpty && selectedSpaceFeeType == .Paid) {
            feeCheck = true
        } else {
            feeCheck = false
        }
        
        if(spaceFeeTextFieldtext.isEmpty && selectedSpaceFeeType == .Free) {
            feeCheck = true
        }
        
        if(titleCheck && photosCheck && descriptionCheck && startingDateCheck  && endingDateCheck && locationCheck && addressCheck && feeCheck) {
            isDisabledCreateButton = false
        } else {
            isDisabledCreateButton = true
        }
    }
    
    // MARK: createAHappening
    func createAHappening(completionHandler: @escaping (_ status: Bool) -> ()) {
        
        isDisabledCreateButton = true
        isDisabledCreateAHappeningView = true
        isPresentedCreatingProgress = true
        
        guard let userUID = currentUser.currentUserUID else {
            alertItemForCreateAHappeningView = AlertItemModel(title: "Unable to Create", message: "Please try again in a moment.")
            completionHandler(false)
            return
        }
        
        var base64PhotosDataArray: [String]? = [String]()
        
        for index in happeningPhotosArray.indices {
            guard let data = happeningPhotosArray[index].jpegData(compressionQuality: 0.1) else {
                alertItemForCreateAHappeningView = AlertItemModel(title: "Unable to Create", message: "Please try again in a moment.")
                completionHandler(false)
                return
            }
            
            // Convert image Data to base64 encodded string
            let imageBase64String = data.base64EncodedString()
            
            base64PhotosDataArray?.append(imageBase64String)
        }
        
        guard let base64PhotoData = base64PhotosDataArray else {
            alertItemForCreateAHappeningView = AlertItemModel(title: "Unable to Create", message: "Please try again in a moment.")
            completionHandler(false)
            return
        }
        
        lazy var functions = Functions.functions()
        
        let data: [String:Any] = [
            "collectionName" : "Users/\(userUID)/HappeningData",
            "docID" : UUID().uuidString,
            "userUID" : userUID,
            "title" : happeningTitleTextFieldText,
            "photosData" : base64PhotoData,
            "fieldName" : "ThumbnailPhoto",
            "description" : happeningDescriptionTextEditorText,
            "startingDateAndTime" : selectedStartingDT,
            "endingDateAndTime" : selectedEndingDT,
            "standardStartingDT" : standardStartingDT,
            "standardEndingDT" : standardEndingDT,
            "latitude" : MyHappeningLocationMapViewModel.shared.happeningLocation[0].latitude,
            "longitude" : MyHappeningLocationMapViewModel.shared.happeningLocation[0].longitude,
            "address" : happeningAddressTextFieldText,
            "secureAddress" : MyHappeningLocationMapViewModel.shared.happeningLocation[0].secureAddress,
            "spaces" : noOfSpaces,
            "spaceFee" : spaceFeeTextFieldtext != "" ? "\(spaceFeeTextFieldtext) \(currency)" : "Free",
            "spaceFlag": "open",
            "dueFlag": "live",
            "disputeFlag": false,
            "numberOfDisputes": 0,
            "uid": userUID,
            "spaceFeeNo": spaceFeeTextFieldtext.isEmpty ? 0 : Int(spaceFeeTextFieldtext)!,
            "participators": [String]()
        ]
        
        functions.httpsCallable("createAHappening").call(data) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                completionHandler(false)
                self.alertItemForCreateAHappeningView = AlertItemModel(title: "Unable to Create", message: "Please try again in a moment.")
                return
            } else {
                
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        completionHandler(false)
                        self.alertItemForCreateAHappeningView = AlertItemModel(title: "Unable to Create", message: "Please try again in a moment.")
                        return
                    }
                
                print("🖤🖤🖤 isCompleted: \(status)")
                print("The Happening Has Been Created Successfully. 🤓🤓🤓")
                self.resetHappeningData()
                completionHandler(status)
            }
        }
    }
    
    // MARK: resetHappeningData
    func resetHappeningData() {
        isPresentedCreatingProgress = false
        isDisabledCreateButton = false
        isDisabledCreateAHappeningView = false
        
        happeningTitleTextFieldText = ""
        happeningPhotosArray.removeAll()
        happeningDescriptionTextEditorText = ""
        startingDateTimeSelection = Date()
        endingDateTimeSelection = Date()
        MyHappeningLocationMapViewModel.shared.removeHappeningAnnotation()
        MyHappeningLocationMapViewModel.shared.whenClickOnCancel()
        happeningAddressTextFieldText = ""
        noOfSpaces = 1
        spaceFeeTextFieldtext = ""
        selectedSpaceFeeType = .Free
    }
}
