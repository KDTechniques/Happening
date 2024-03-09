//
//  NavigationBarTrailingItemsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct NavigationBarTrailingItemsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    @EnvironmentObject var imageBasedMemoryVM: ImageBasedMemoryViewModel
    
    // MARK: BODY
    var body: some View {
        HStack {
            Button {
                imageBasedMemoryVM.isPresentedPhotoLibrary = false
                imageBasedMemoryVM.isPresentedImagePickerSheet = true
                imageBasedMemoryVM.isPresenetedCameraSheet = true
            } label: {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                    .padding(10)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Circle())
            }
            .fullScreenCover(isPresented: $imageBasedMemoryVM.isPresenetedCameraSheet,
                             onDismiss: { imageBasedMemoryVM.isPresentedPhotoLibrary = false },
                             content: { ImageBasedMemorySheetView().dynamicTypeSize(.large)}
            )
            
            Button {
                textBasedMemoryVM.isPresentedTextBasedMemorySheet = true
            } label: {
                Image(systemName: "text.alignleft")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                    .padding(10)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Circle())
            }
            .fullScreenCover(isPresented: $textBasedMemoryVM.isPresentedTextBasedMemorySheet) { TextBasedMemorySheetView().dynamicTypeSize(.large) }
        }
    }
}

// MARK: PREVIEWS
struct NavigationBarTrailingItems_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                HStack {
                    Spacer()
                    NavigationBarTrailingItemsView()
                        .preferredColorScheme(.dark)
                        .padding(.trailing, 20)
                }
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    NavigationBarTrailingItemsView()
                        .padding(.trailing, 20)
                }
                Spacer()
            }
        }
        .environmentObject(MemoriesViewModel())
        .environmentObject(TextBasedMemoryViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(ImageBasedMemoryViewModel())
    }
}
