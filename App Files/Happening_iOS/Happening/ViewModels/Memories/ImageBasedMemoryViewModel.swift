//
//  ImageBasedMemoryViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-29.
//

import Foundation
import SwiftUI
import Firebase
import PencilKit

class ImageBasedMemoryViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = ImageBasedMemoryViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to TextBasedMemoryViewModel
    let textBasedMemoryVM = TextBasedMemoryViewModel.shared
    
    // reference to Firebase
    let db = Firestore.firestore()
    
    // status to choose photo library over camera
    @Published var isPresentedPhotoLibrary: Bool = false
    
    // present a sheet to take a photo using camera or pick an image from photo library
    @Published var isPresentedImagePickerSheet: Bool = false
    
    // status to choose camera over photo library
    @Published var isPresenetedCameraSheet: Bool = false
    
    // controls the image of the memory
    @Published var image: UIImage? = nil
    
    // controls the text of the text editor in CameraSheetView
    @Published var textEditortext: String = ""
    
    // controls the temporary text of the text editor in CameraSheetView
    @Published var temporarytextEditortext: String = ""
    
    // controls the canves view use to draw
    @Published var canvasView = PKCanvasView()
    
    // controls the default color for drawing
    @Published var currentColor: Color = Color("AppColor")
    
    // controls the drag offset of the vertical color picker
    @Published var dragOffset: CGSize = .zero
    
    // controls the height of the vertical color picker
    @Published var colorPickerHeight: CGFloat = .zero
    
    // controls the opacity of the circle in the background of the drawing button
    @Published var drawingButtonOpacity: Bool = false
    
    // controls the text button icon opacity
    @Published var textButtonOpacity: Bool = false
    
    // status whether the user is touching the vertical color picker or not
    @Published var isTouching: Bool = false
    
    // present an an alert when user is trying to discard the image based memory with a drawings on it
    @Published var isPresentedDrawingClearAlert: Bool = false
    
    // drawing content that is converted to a image
    @Published var DrawingContentAsImage: UIImage? = nil
    
    // controls the magnification of the image based memory
    @Published var currentMagnification: CGFloat = 1
    
    // controls the drag offset of the image based memory
    @Published var imagedragOffset: CGSize = .zero
    
    // controls the position of the image based memory
    @Published var imagePosition: CGSize = .zero
    
    // present an alert if somthing goes wrong when picking an image from photo library to image based memory
    @Published var isAlertPresented: Bool = false
    
    // status whether the image is added to the image based memory or not
    @Published var isAddedSuccessful: Bool = false
    
    // MARK: INITIALIZERS
    init() {
        
    }
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: imageMagnificationGestureOnEnded
    func imageMagnificationGestureOnEnded(value: CGFloat) {
        currentMagnification *= value
        if(currentMagnification < 1) {
            imagedragOffset = .zero
            imagePosition = .zero
            currentMagnification = 1
        }
    }
    
    
    // MARK: DrawingCanvasViewMagnificationGestureOnEnded
    func DrawingCanvasViewMagnificationGestureOnEnded(value: CGFloat) {
        currentMagnification *= value
        if(currentMagnification < 1) {
            imagedragOffset = .zero
            imagePosition = .zero
            currentMagnification = 1
        }
    }
    
    
    // MARK: resetCameraSheet
    func resetCameraSheet() {
        temporarytextEditortext = textEditortext
        image = nil
        canvasView.drawing = PKDrawing()
        currentColor = Color("AppColor")
        drawingButtonOpacity = false
        textButtonOpacity = false
        colorPickerHeight = 0
        imagedragOffset = .zero
        imagePosition = .zero
        currentMagnification = 1
        textEditortext = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isPresenetedCameraSheet = false
        }
    }
    
    
    // MARK: saveImageBasedMemoryImageToPhotoLibrary
    func saveImageBasedMemoryImageToPhotoLibrary() {
        guard let inputImage = DrawingContentAsImage else { return }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)
    }
    
    
    // MARK: submitImageBasedMemoryToFirestore
    func submitImageBasedMemoryToFirestore(imageBasedMemoryImage: UIImage, caption: String, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        guard
            let myUserUID = currentUser.currentUserUID,
            let compressedImageData = imageBasedMemoryImage.jpegData(compressionQuality: 0.1) else {
                completion(.error)
                return
            }
        
        let compressedBase64ImageData = compressedImageData.base64EncodedString()
        
        lazy var functions = Functions.functions()
        
        let docID = UUID().uuidString
        
        let uploadingData:[String: Any] = [
            "docID": docID,
            "myDocID": myUserUID,
            "imageData": compressedBase64ImageData,
            "caption": caption,
            "uploadedDate": getCurrentDateAndTime(format: "MMM d, yyyy"),  // ex: May 22, 2022
            "uploadedTime": getCurrentDateAndTime(format: "h:mm a"), // ex: 4:46 PM
            "fullUploadedDT": getCurrentDateAndTime(format: "MM-dd-yyyy HH:mm:ss"), // ex: 05-02-2022 19:47:19
        ]
        
        let storingData:[String: Any] = [
            "DocID": docID,
            "MemoryType": "imageBased",
            "MyDocID": myUserUID,
            "Caption": caption,
            "UploadedDate": getCurrentDateAndTime(format: "MMM d, yyyy"),  // ex: May 22, 2022
            "UploadedTime": getCurrentDateAndTime(format: "h:mm a"), // ex: 4:46 PM
            "FullUploadedDT": getCurrentDateAndTime(format: "MM-dd-yyyy HH:mm:ss"), // ex: 22-5-2022 21:10:16
        ]
        
        /// this is where pending memory items is being created and store it in a an array and save to user defaults
        MemoriesViewModel.shared.handlePendingUploadMyMemories(
            docID: docID,
            storingData: storingData,
            compressedThumbnailImageData: compressedImageData,
            compressedImageData: compressedImageData
        )
        
        functions.httpsCallable("uploadAnImageBasedMemory").call(uploadingData) { result, error in
            
            if let error = error  {
                print("Error: \(error.localizedDescription)")
                /// if something goes wrong while uploading, that purticular memory item will be direct to handle it as a failed item.
                MemoriesViewModel.shared.handleUploadFailedMyMemories(
                    docID: docID,
                    storingData: storingData,
                    compressedThumbnailImageData: compressedImageData,
                    compressedImageData: compressedImageData
                )
                completion(.error)
                return
            } else {
                guard
                    let result = result,
                    let data = result.data as? [String:Any],
                    let status = data["isCompleted"] as? Bool else {
                        /// if something goes wrong while uploading, that purticular memory item will be direct to handle it as a failed item.
                        MemoriesViewModel.shared.handleUploadFailedMyMemories(
                            docID: docID,
                            storingData: storingData,
                            compressedThumbnailImageData: compressedImageData,
                            compressedImageData: compressedImageData
                        )
                        completion(.error)
                        return
                    }
                
                if status {
                    print("🖤🖤🖤 isCompleted: \(status)")
                    print("Image-Based Memory Has Been Uploaded Successfully. ❤️❤️❤️")
                    /// if the memory data has been uploaded to firestore successfully, the data wil be saved to an array in user defaults
                    MemoriesViewModel.shared.handleUploadSucceedMyMemories(
                        docID: docID,
                        storingData: storingData,
                        compressedThumbnailImageData: compressedImageData,
                        compressedImageData: compressedImageData
                    )
                    vibrate(type: .success)
                    completion(.success)
                } else {
                    print("☹️☹️☹️ isCompleted: \(status)")
                    print("Unable To Upload The Image-Based Memory.🚫🚫🚫")
                    /// if something goes wrong while uploading, that purticular memory item will be direct to handle it as a failed item.
                    MemoriesViewModel.shared.handleUploadFailedMyMemories(
                        docID: docID,
                        storingData: storingData,
                        compressedThumbnailImageData: compressedImageData,
                        compressedImageData: compressedImageData
                    )
                    completion(.error)
                    return
                }
            }
        }
    }
    
    
    // MARK: pendingNFailedImageBasedMyMemoriesReuploader
    func pendingNFailedImageBasedMyMemoriesReuploader() {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            return
        }
        
        let tempFilteredArray = MemoriesViewModel.shared.failedNSucceededMyMemoriesDataArray.filter {
            ($0.uploadStatus == .pending || $0.uploadStatus == .failed) && $0.memoryType == .imageBased
        }
        
        for item in tempFilteredArray {
            
            lazy var functions = Functions.functions()
            
            let compressedBase64ImageData = item.compressedImageData!.base64EncodedString()
            
            let uploadingData:[String: Any] = [
                "docID": item.id,
                "myDocID": myUserUID,
                "imageData": compressedBase64ImageData,
                "caption": item.caption,
                "uploadedDate": getCurrentDateAndTime(format: "MMM d, yyyy"),  // ex: May 22, 2022
                "uploadedTime": getCurrentDateAndTime(format: "h:mm a"), // ex: 4:46 PM
                "fullUploadedDT": getCurrentDateAndTime(format: "MM-dd-yyyy HH:mm:ss"), // ex: 05-02-2022 19:47:19
            ]
            
            let storingData:[String: Any] = [
                "DocID": item.id,
                "MemoryType": "imageBased",
                "MyDocID": myUserUID,
                "Caption": item.caption,
                "UploadedDate": getCurrentDateAndTime(format: "MMM d, yyyy"),  // ex: May 22, 2022
                "UploadedTime": getCurrentDateAndTime(format: "h:mm a"), // ex: 4:46 PM
                "FullUploadedDT": getCurrentDateAndTime(format: "MM-dd-yyyy HH:mm:ss"), // ex: 22-5-2022 21:10:16
            ]
            
            let object = MyMemoriesModel(
                uuid: item.id,
                data: storingData,
                compressedThumbnailImageData: item.compressedImageData,
                compressedImageData: item.compressedImageData,
                seenersData: [],
                uploadStatus: .uploaded
            )
            
            functions.httpsCallable("uploadAnImageBasedMemory").call(uploadingData) { result, error in
                
                if let error = error  {
                    print("Error: \(error.localizedDescription)")
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
                        
                        var tempPendingDataArray = MemoriesViewModel.shared.getExistingCustomMyMemoriesDataFromUserDefaults(keyName: MemoriesViewModel.shared.pendingUploadMyMemoriesDataArrayUserDefaultsKeyName)
                        var tempFailedDataArray = MemoriesViewModel.shared.getExistingCustomMyMemoriesDataFromUserDefaults(keyName: MemoriesViewModel.shared.failedMyMemoriesDataArrayUserDefaultsKeyName)
                        
                        /// remove the upload succeed item from upload failed items array in user defaults or upload pending items array in user defaults
                        tempPendingDataArray.removeAll(where: { $0.id == object.id })
                        tempFailedDataArray.removeAll(where: { $0.id == object.id })
                        
                        /// save the updated arrays back to user defaults
                        MemoriesViewModel.shared.saveCustomMemoriesDataArrayToUserDefaults(array: tempPendingDataArray, keyName: MemoriesViewModel.shared.pendingUploadMyMemoriesDataArrayUserDefaultsKeyName)
                        
                        MemoriesViewModel.shared.saveCustomMemoriesDataArrayToUserDefaults(array: tempFailedDataArray, keyName: MemoriesViewModel.shared.failedMyMemoriesDataArrayUserDefaultsKeyName)
                        
                        /// once the required item is removed from the required array in user defaults, save the updated item to succeed memory items array in user defaults
                        let tempSucceedDataArray = MemoriesViewModel.shared.getExistingCustomMyMemoriesDataFromUserDefaults(keyName: MemoriesViewModel.shared.myMemoriesDataArrayUserDefaultsKeyName)
                        
                        MemoriesViewModel.shared.saveCustomMemoriesDataToUserDefaults(
                            object: object,
                            array: tempSucceedDataArray,
                            keyName: MemoriesViewModel.shared.myMemoriesDataArrayUserDefaultsKeyName
                        )
                        print("Image-Based Memory Has Been Re-Uploaded Successfully. ❤️❤️❤️")
                    } else {
                        print("☹️☹️☹️ isCompleted: \(status)")
                        print("Unable To Re-Upload The Image-Based Memory.🚫🚫🚫")
                        return
                    }
                }
            }
        }
    }
}
