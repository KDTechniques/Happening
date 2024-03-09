import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var imageErrorAlert: Bool
    @Binding var isPresentedPhotoLibrary: Bool
    @Binding var isAddedSuccessful: Bool
    @Binding var isPresentedCameraSheet: Bool
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return Coordinator(imagePicker: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .photoLibrary
        } else {
            if(isPresentedPhotoLibrary) {
                picker.sourceType = .photoLibrary
            } else {
                picker.sourceType = .camera
            }
        }
        return picker
    }
    
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let imagePicker: ImagePicker
        
        init(imagePicker: ImagePicker){
            self.imagePicker = imagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                guard let data = image.jpegData(compressionQuality: 0.1), let compressedImage = UIImage(data: data) else {
                    //show error  or alert
                    imagePicker.imageErrorAlert.toggle()
                    return
                }
                imagePicker.image = compressedImage
                print("Image added successful.")
                imagePicker.isAddedSuccessful = true
            } else {
                // return an error show an alert
                imagePicker.imageErrorAlert = true
            }
            picker.dismiss(animated: true)
            imagePicker.isPresentedPhotoLibrary = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Canceled.")
            picker.dismiss(animated: true)
            imagePicker.isPresentedCameraSheet = false
            imagePicker.isPresentedPhotoLibrary = false
        }
    }
}
