//
//  ImageSaverToPhotoLibrary.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-10.
//

import Foundation
import SwiftUI

final class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Photo has been saved successfully.")
    }
}

// MARK: Usage
/*
guard let inputImage = imageVariableGoesHere else { return }
let imageSaver = ImageSaver()
imageSaver.writeToPhotoAlbum(image: inputImage)
*/
