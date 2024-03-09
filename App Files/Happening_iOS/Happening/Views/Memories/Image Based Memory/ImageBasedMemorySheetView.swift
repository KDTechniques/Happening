//
//  ImageBasedMemorySheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct ImageBasedMemorySheetView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var imageBasedMemoryVM: ImageBasedMemoryViewModel
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    @FocusState private var isTextEditorFocused: Bool
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            ImageWithDrawingsView(isTextEditorFocused: $isTextEditorFocused)
            
            if(imageBasedMemoryVM.isAddedSuccessful) {
                VStack {
                    ImageBasedMemoryOverlappingActionButtonsView()
                    
                    Spacer()
                    
                    ImageBasedMemoryTextFieldView(isTextEditorFocused: $isTextEditorFocused, textFieldText: $imageBasedMemoryVM.textEditortext)
                }
            }
        }
        .onAppear(perform: {
            memoriesVM.pauseMemoryUploadDTCalculatorTimer()
            
            imageBasedMemoryVM.isAddedSuccessful = false
        })
        .onDisappear(perform: {
            memoriesVM.resumeMemoryUploadDTCalculatorTimer()
            
            imageBasedMemoryVM.isAddedSuccessful = false
        })
        .fullScreenCover(isPresented: $imageBasedMemoryVM.isPresentedImagePickerSheet) {
            CameraSheetView()
        }
    }
}

// MARK: PREVIEWS
struct ImageBasedMemorySheetView_Previews: PreviewProvider {
    static var previews: some View {
        ImageBasedMemorySheetView()
            .environmentObject(MemoriesViewModel())
            .environmentObject(ColorTheme())
            .environmentObject(ImageBasedMemoryViewModel())
    }
}
