//
//  CameraSheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-07.
//

import SwiftUI

struct CameraSheetView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var imageBasedMemoryVM: ImageBasedMemoryViewModel
    
    // MARK: BODY
    var body: some View {
        ZStack {
            ImagePicker(image: $imageBasedMemoryVM.image,
                        imageErrorAlert: $imageBasedMemoryVM.isAlertPresented,
                        isPresentedPhotoLibrary: $imageBasedMemoryVM.isPresentedPhotoLibrary,
                        isAddedSuccessful: $imageBasedMemoryVM.isAddedSuccessful,
                        isPresentedCameraSheet: $imageBasedMemoryVM.isPresenetedCameraSheet)
            
            HStack {
                if !imageBasedMemoryVM.isPresentedPhotoLibrary {
                    Button(action: {
                        imageBasedMemoryVM.isPresentedImagePickerSheet = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            imageBasedMemoryVM.isPresentedPhotoLibrary = true
                            imageBasedMemoryVM.isPresentedImagePickerSheet = true
                        }
                    }, label: {
                        Image(systemName: "photo.circle.fill")
                            .font(.system(size: 34))
                            .foregroundColor(Color.white)
                            .background(Circle().fill(.ultraThinMaterial).opacity(0.5))
                    })
                }
                
                Spacer()
            }
            .padding(.leading, 12)
        }
        .dynamicTypeSize(.large)
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: PREVIEWS
struct CameraSheetView_Previews: PreviewProvider {
    static var previews: some View {
        CameraSheetView()
            .preferredColorScheme(.dark)
            .environmentObject(MemoriesViewModel())
            .environmentObject(ImageBasedMemoryViewModel())
    }
}

