//
//  PhotoPicker.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-17.
//

import Foundation
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable{
    
    @Binding var image: UIImage?
    @Binding var imageErrorAlert: Bool
    @Binding var isAddedSucess: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker){
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage{
                guard let data = image.jpegData(compressionQuality: 0.1), let compressedImage = UIImage(data: data) else {
                    //show error  or alert
                    self.photoPicker.imageErrorAlert.toggle()
                    return
                }
                self.photoPicker.image = compressedImage
                self.photoPicker.isAddedSucess = true
            } else {
                // return an error show an alert
                self.photoPicker.imageErrorAlert.toggle()
            }
            picker.dismiss(animated: true)
        }
    }
}
