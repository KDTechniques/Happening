//
//  TextBasedMemoryViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-29.
//

import Foundation
import SwiftUI
import Firebase

class TextBasedMemoryViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = TextBasedMemoryViewModel()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // reference to UserDefaults
    let defaults = UserDefaults.standard
    
    // controls the background colors of the text based memory
    let backgroundColorsArray: [String] = [
        "SBColor1",
        "SBColor2",
        "SBColor3",
        "SBColor4",
        "SBColor5",
        "SBColor6",
        "SBColor7",
        "SBColor8",
        "SBColor9",
        "SBColor10",
        "SBColor11",
        "SBColor12",
        "SBColor13",
        "SBColor14",
        "SBColor15",
        "SBColor16",
        "SBColor17",
        "SBColor18",
        "SBColor19",
        "SBColor20",
        "SBColor21"
    ]
    
    // decides the color index of the background colors array of the text based memory
    @Published var selectedColorIndex: Int = .zero
    
    // a guard variable that protects background colors array from overflowing when loop through different background colors
    @Published var guardColorIndex: Int = 1
    
    // controls the font styles of the text based memory
    let customFontTypes = [
        "SFUIDisplay-Medium",
        "Lora-Medium",
        "Norican-Regular",
        "CaveatBrush-Regular",
        "Anton-Regular"
    ]
    
    // decides the font index of the fonts array of the text based memory
    @Published var selectedFontIndex: Int = .zero
    
    // a guard variable that protects fonts array from overflowing when loop through different fonts
    @Published var guardFontIndex: Int = 1
    
    // controls the selected font type name
    @Published var selectedFontType: String = "SFUIDisplay-Medium"
    
    // decides which font size is good for different font styles in different contexts
    let customFontSizes1: [CGFloat] = [37, 38, 32, 40, 29]
    let customFontSizes2: [CGFloat] = [37, 38, 43, 43, 34]
    @Published var customFontSizes3: [CGFloat] = [37, 38, 43, 43, 34]
    
    // controls the text of the text editor in TextBasedMemoryTextEditorView
    @Published var textEditortext: String = ""
    
    // controls the height of the text editor according to different font sizes and no of lines
    @Published var textEditorFrameHeight: Double = 56.0
    
    // count how many times a text reched the max width of the text editor to adjest the height
    @Published var maxWidthReachedCount: Int = .zero
    
    // controls the width of the text string while typing
    @Published var stringWidth: CGFloat = .zero
    
    // controls number of lines have typed in the text editor
    @Published var lineCount: Int = .zero
    
    // decides the text alignment of the text editor text when typing lengthy text strings
    @Published var textAlignment: TextAlignment = .center
    
    // status whether the text field has reached max characters or no of lines
    @Published var isReachedMaxCharactersOrLines: Bool = false
    
    // controls the scale size of the submit button
    @Published var scaleEffectValueOfTextBasedMemorySubmitButton: CGFloat = .zero
    
    // present a sheet for text based status
    @Published var isPresentedTextBasedMemorySheet: Bool = false
    
    
    // all of these duplicate propertis has the same purpose as above ones but only for the 'TextBasedMemoryTextEditorViewAsImage' view
    @Published var __textEditortext: String = ""
    
    @Published var __textAlignment: TextAlignment = .center
    
    @Published var __textEditorFrameHeight: Double = 56.0
    
    @Published var __customFontSizes3: [CGFloat] = [37, 38, 43, 43, 34]
    
    @Published var __selectedFontIndex: Int = .zero
    
    @Published var __stringWidth: CGFloat = .zero
    
    @Published var __maxWidthReachedCount: Int = .zero
    
    @Published var __lineCount: Int = .zero
    
    @Published var __colorName: String = ""
    
    @Published var __fontName: String = ""
    
    // MARK: INITIALIZERS
    init() {
        
    }
    
    
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: onAppearOfTextBasedMemorySheetView
    func onAppearOfTextBasedMemorySheetView() {
        let randomColorIndex = Int.random(in: 0..<21)
        guardColorIndex = randomColorIndex+1
        selectedColorIndex = randomColorIndex
    }
    
    
    // MARK: limitReachedAlertMessagePresenter
    func limitReachedAlertMessagePresenter() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isReachedMaxCharactersOrLines = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isReachedMaxCharactersOrLines = false
            }
        }
    }
    
    
    // MARK: limitText
    func limitText(_ upper: Int) {
        if(textEditortext.count > upper) {
            textEditortext = String(textEditortext.prefix(upper))
            limitReachedAlertMessagePresenter()
            print("700 characters limit has reached...")
        }
    }
    
    
    // MARK: onChangeOfTextEditorText
    func onChangeOfTextEditorText(character: String) {
        if(textEditortext.count > 0) {
            withAnimation(.spring()) {
                scaleEffectValueOfTextBasedMemorySubmitButton = 1
            }
        } else {
            withAnimation(.spring()) {
                scaleEffectValueOfTextBasedMemorySubmitButton = CGFloat.ulpOfOne
            }
        }
        
        if(textEditortext.count >= 170) {
            textAlignment = .leading
        }
        
        if(self.textEditortext.count < 170) {
            textAlignment = .center
        }
        
        if(self.textEditortext.filter { $0 == "\n" }.count == 12) {
            print("12 lines limit has reached...")
            textEditortext = String(character.dropLast())
            limitReachedAlertMessagePresenter()
        }
        
        if(textEditortext.count >= 50 && textEditortext.count < 200) {
            customFontSizes3[selectedFontIndex] = customFontSizes2[selectedFontIndex]
            customFontSizes3[selectedFontIndex] -= 14
        }
        
        if(textEditortext.count >= 200) {
            customFontSizes3[selectedFontIndex] = customFontSizes2[selectedFontIndex]
            customFontSizes3[selectedFontIndex] -= 22
        }
        
        if(textEditortext.count < 50) {
            customFontSizes3[selectedFontIndex] = customFontSizes2[selectedFontIndex]
        }
        
        stringWidth = textEditortext.widthOfString(
            usingFont: UIFont.systemFont(ofSize: customFontSizes3[selectedFontIndex], weight: .black)
        )
        
        if(textEditortext.filter { $0 == "\n" }.count == 0 || maxWidthReachedCount == 0) {
            textEditorFrameHeight = 56.0
        }
        
        maxWidthReachedCount = (Int(stringWidth) / Int(UIScreen.main.bounds.size.width - 60)) // 0
        
        lineCount = textEditortext.filter { $0 == "\n" }.count + maxWidthReachedCount + 1 // 1
        
        textEditorFrameHeight =  (Double(customFontSizes3[selectedFontIndex]) + 20) * Double(lineCount)
    }
    
    
    // MARK: onChangeOfTextEditorText
    func onChangeOfTextEditorText() {
        
        if(__textEditortext.count >= 170) {
            __textAlignment = .leading
        }
        
        if(__textEditortext.count < 170) {
            __textAlignment = .center
        }
        
        if(__textEditortext.count >= 50 && __textEditortext.count < 200) {
            __customFontSizes3[__selectedFontIndex] = customFontSizes2[__selectedFontIndex]
            __customFontSizes3[__selectedFontIndex] -= 14
        }
        
        if(__textEditortext.count >= 200) {
            __customFontSizes3[__selectedFontIndex] = customFontSizes2[__selectedFontIndex]
            __customFontSizes3[__selectedFontIndex] -= 22
        }
        
        if(__textEditortext.count < 50) {
            __customFontSizes3[__selectedFontIndex] = customFontSizes2[__selectedFontIndex]
        }
        
        __stringWidth = __textEditortext.widthOfString(
            usingFont: UIFont.systemFont(ofSize: __customFontSizes3[__selectedFontIndex], weight: .black)
        )
        
        if(__textEditortext.filter { $0 == "\n" }.count == 0 || __maxWidthReachedCount == 0) {
            __textEditorFrameHeight = 56.0
        }
        
        __maxWidthReachedCount = (Int(__stringWidth) / Int(UIScreen.main.bounds.size.width - 60)) // 0
        
        __lineCount = __textEditortext.filter { $0 == "\n" }.count + __maxWidthReachedCount + 1 // 1
        
        __textEditorFrameHeight =  (Double(__customFontSizes3[__selectedFontIndex]) + 20) * Double(__lineCount)
    }
    
    
    // MARK: resetTextBasedMemorySheet
    
    func resetTextBasedMemorySheet() {
        isPresentedTextBasedMemorySheet = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.textEditortext = ""
            self.selectedFontIndex = 0
            self.guardFontIndex = 1
            self.selectedFontType = self.customFontTypes[self.selectedFontIndex]
            self.selectedColorIndex = 0
            self.guardColorIndex = 1
        }
    }
    
    
    // MARK: changeFontStyle
    func changeFontStyle() {
        guardFontIndex += 1
        if(guardFontIndex == customFontTypes.count + 1) {
            selectedFontIndex = 0
            guardFontIndex = 1
        } else {
            selectedFontIndex += 1
        }
        
        selectedFontType = customFontTypes[selectedFontIndex]
    }
    
    
    // MARK: changeBackgroundColor
    func changeBackgroundColor() {
        self.guardColorIndex += 1
        if(guardColorIndex == backgroundColorsArray.count + 1) {
            selectedColorIndex = 0
            guardColorIndex = 1
        } else {
            selectedColorIndex += 1
        }
    }
    
    
    // MARK: submitTextBasedMemoryToFirestore
    func submitTextBasedMemoryToFirestore(textBasedMemoryAsImage: UIImage, completion: @escaping (_ status: AsyncFunctionStatusTypes) -> ()) {
        
        guard let myUserUID = currentUser.currentUserUID else {
            resetTextBasedMemorySheet()
            completion(.error)
            return
        }
        
        lazy var functions = Functions.functions()
        
        let docID = UUID().uuidString
        
        let uploadingData:[String: Any] = [
            "docID": docID,
            "memoryType": "textBased",
            "myDocID": myUserUID,
            "colorName": backgroundColorsArray[selectedColorIndex],
            "fontName": selectedFontType,
            "text": textEditortext,
            "uploadedDate": getCurrentDateAndTime(format: "MMM d, yyyy"),  // ex: May 22, 2022
            "uploadedTime": getCurrentDateAndTime(format: "h:mm a"), // ex: 4:46 PM
            "fullUploadedDT": getCurrentDateAndTime(format: "MM-dd-yyyy HH:mm:ss"), // ex: 05-02-2022 19:47:19
        ]
        
        let storingData:[String: Any] = [
            "DocID": docID,
            "MemoryType": "textBased",
            "MyDocID": myUserUID,
            "ColorName": backgroundColorsArray[selectedColorIndex],
            "FontName": selectedFontType,
            "Text": textEditortext,
            "UploadedDate": getCurrentDateAndTime(format: "MMM d, yyyy"),  // ex: May 22, 2022
            "UploadedTime": getCurrentDateAndTime(format: "h:mm a"), // ex: 4:46 PM
            "FullUploadedDT": getCurrentDateAndTime(format: "MM-dd-yyyy HH:mm:ss"), // ex: 22-5-2022 21:10:16
        ]
        
        guard let compressedImageData: Data = textBasedMemoryAsImage.jpegData(compressionQuality: 1) else {
            print("error compressing image data.")
            return
        }
        
        /// this is where pending memory items is being created and store it in a an array and save to user defaults
        MemoriesViewModel.shared.handlePendingUploadMyMemories(
            docID: docID,
            storingData: storingData,
            compressedThumbnailImageData: compressedImageData,
            compressedImageData: compressedImageData
        )
        
        resetTextBasedMemorySheet()
        
        functions.httpsCallable("uploadATextBasedMemory").call(uploadingData) { result, error in
            
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
                    print("Text-Based Memory Has Been Uploaded Successfully. ❤️❤️❤️")
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
                    print("Unable To Upload The Text-Based Memory.🚫🚫🚫")
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
    
    
    // MARK: pendingNFailedTextBasedMyMemoriesReuploader
    func pendingNFailedTextBasedMyMemoriesReuploader() {
        
        guard let myUserUID = currentUser.currentUserUID else {
            print("my user uid nil.")
            return
        }
        
        let tempFilteredArray = MemoriesViewModel.shared.failedNSucceededMyMemoriesDataArray.filter {
            ($0.uploadStatus == .pending || $0.uploadStatus == .failed) && $0.memoryType == .textBased
        }
        
        for item in tempFilteredArray {
            
            lazy var functions = Functions.functions()
            
            let uploadingData:[String: Any] = [
                "docID": item.id,
                "memoryType": "textBased",
                "myDocID": myUserUID,
                "colorName": item.colorName,
                "fontName": item.fontName,
                "text": item.text,
                "uploadedDate": item.uploadedDate,  // ex: May 22, 2022
                "uploadedTime": item.uploadedTime, // ex: 4:46 PM
                "fullUploadedDT": item.fullUploadedDT, // ex: 22-5-2022 21:10:16
            ]
            
            let storingData:[String: Any] = [
                "DocID": item.id,
                "MemoryType": "textBased",
                "MyDocID": myUserUID,
                "ColorName": item.colorName,
                "FontName": item.fontName,
                "Text": item.text,
                "UploadedDate": item.uploadedDate,  // ex: May 22, 2022
                "UploadedTime": item.uploadedTime, // ex: 4:46 PM
                "FullUploadedDT": item.fullUploadedDT, // ex: 22-5-2022 21:10:16
            ]
            
            let object = MyMemoriesModel(
                uuid: item.id,
                data: storingData,
                compressedThumbnailImageData: item.compressedImageData,
                compressedImageData: item.compressedImageData,
                seenersData: [],
                uploadStatus: .uploaded
            )
            
            functions.httpsCallable("uploadATextBasedMemory").call(uploadingData) { result, error in
                
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
                        
                        print("Text-Based Memory Has Been Re-Uploaded Successfully. ❤️❤️❤️")
                    } else {
                        print("☹️☹️☹️ isCompleted: \(status)")
                        print("Unable To Re-Upload The Text-Based Memory.🚫🚫🚫")
                        return
                    }
                }
            }
        }
    }
}
