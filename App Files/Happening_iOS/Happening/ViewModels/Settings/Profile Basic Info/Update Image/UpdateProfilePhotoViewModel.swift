//
//  UpdateProfilePhotoViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-20.
//

import Foundation
import SwiftUI
import Firebase

class UpdateProfilePhotoViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    //singleton
    static let shared = UpdateProfilePhotoViewModel()
    
    // reference to ProfileBasicInfoViewModel
    let profileBasicInfoViewModel = ProfileBasicInfoViewModel.shared
    
    // controls the confirmation dialog to edit image button
    @Published var isPresentedEditImageConfirmationDialog: Bool = false
    // temporary image that need to be uploaded to database and will be nil after uploading
    @Published var theImageThatNeedsToBeApproved: UIImage? = nil
    // controls the temporary image uploading sheet
    @Published var isPresentedEditImageSheet: Bool = false
    // controls the full cover sheet to upload image
    @Published var isPresentedEditImageFullCoverSheet: Bool = false
    // controls error alert to uploading image
    @Published var isPresentedErrorAlert: Bool = false
    // controls the photo library picker to upload image
    @Published var isPresentedPhotoLibrary: Bool = false
    // controls the camera sheet to upload image
    @Published var isPresentedCameraSheet: Bool = false
    // status of the upload image
    @Published var isAddedSuccessfulTemporaryImage: Bool = false {
        didSet{
            self.isPresentedEditImageSheet = true
        }
    }
    // controls the visibility of upload button
    @Published var showUploadButton: Bool = true
    // changes the progress view text
    @Published var progressViewText: ProgressViewText = .text1
    // controls the progress amount of the upload progress bar
    @Published var uploadAmount: Double = .zero
    // status of success of the profile photo upload
    @Published var isUploadedCompleted: Bool = false
    // progress view text options
    enum ProgressViewText: String {
        case text1 = "It may take a few seconds to upload your profile photo."
        case text2 = "We will let you know once it is uploaded."
    }
    // picker selection options
    enum PickerSelection {
        case photo
        case camera
    }
    
    // reference to firebase firestore
    let db = Firestore.firestore()
    
    // present an alert item for UploadImageSheetView
    @Published var alertItem1ForuploadImageSheetView: AlertItemModel?
    
    // present an alert item for UploadImageSheetView
    @Published var alertItem2ForuploadImageSheetView: AlertItemModel?
    
    // reference to User Defaults
    let defaults = UserDefaults.standard
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: savePhotoToPhotoLibrary
    func savePhotoToPhotoLibrary() {
        guard let data = defaults.data(forKey: profileBasicInfoViewModel.profilePhotoUserDefaultsKeyName) else { return }
        
        let snapshot: UIImage = ZStack {
            Image(uiImage: UIImage(data: data)!)
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
        .asImage()
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: snapshot)
    }
    
    // MARK: openPhotoOrCameraPicker
    func openPhotoOrCameraPicker(selction: PickerSelection) {
        
        if(selction == .photo) {
            isPresentedCameraSheet = false
            isPresentedPhotoLibrary = true
        } else {
            isPresentedPhotoLibrary = false
            isPresentedCameraSheet = true
        }
        
        isPresentedEditImageFullCoverSheet = true
    }
    
    // MARK: uploadProfilePhoto
    func uploadProfilePhotoToFirestore() {
        
        guard let currentUserUID = CurrentUser.shared.currentUserUID else {
            print("Error Getting Current User's UID. 🙁🙁🙁")
            return
        }
        
        guard let photo = theImageThatNeedsToBeApproved else { return }
        
        guard let photoData = photo.jpegData(compressionQuality: 0.1) else { return }
        
        let profilePhotoReference = Storage.storage().reference()
            .child("Pending Approvals/Profile Pictures/\(currentUserUID)")
            .child(currentUserUID)
        
        let randomNumber = Int.random(in: 91...99)
        
        let uploadTask = profilePhotoReference.putData(photoData, metadata: nil) { _, error in
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            } else {
                profilePhotoReference.downloadURL { url, error in
                    if error != nil {
                        print("Error: \(String(describing: error?.localizedDescription))")
                        return
                    } else {
                        guard let url = url else {
                            print("Error: \(String(describing: error?.localizedDescription))")
                            return
                        }
                        let photoURLString = url.absoluteString
                        
                        self.db
                            .collection("Users/\(currentUserUID)/PendingApprovalData")
                            .document(currentUserUID)
                            .setData(["Profile Photo":photoURLString]) { error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                    return
                                } else {
                                    self.db
                                        .collection("Users")
                                        .document(currentUserUID)
                                        .updateData(["pendingProfilePhotoApproval": true]) { error in
                                            if let error = error {
                                                print("Error: \(error.localizedDescription)")
                                                return
                                            } else {
                                                self.uploadAmount += Double(100 - randomNumber)
                                                self.isUploadedCompleted = true
                                                vibrate(type: .success)
                                                print("New Profile Photo Has Been Uploaded to Forestore Successfully. 👍🏻👍🏻👍🏻")
                                            }
                                        }
                                    
                                }
                            }
                    }
                }
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            self.uploadAmount = snapshot.progress!.fractionCompleted * Double(randomNumber)
            if(self.uploadAmount > 70) {
                self.progressViewText = .text2
            }
        }
        
        showUploadButton = false
    }
    
    // MARK: resetUpload
    func resetUploadImageSheetView() {
        isPresentedEditImageSheet = false
        showUploadButton = true
        progressViewText = .text1
        uploadAmount = .zero
        isUploadedCompleted = false
        theImageThatNeedsToBeApproved = nil
        print("Image data has been reset successfully.")
    }
}
