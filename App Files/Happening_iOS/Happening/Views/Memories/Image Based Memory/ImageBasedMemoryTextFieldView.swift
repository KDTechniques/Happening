//
//  ImageBasedMemoryTextFieldView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-07.
//

import SwiftUI

struct ImageBasedMemoryTextFieldView: View {
    
    // MARK: PROPERTIES
    @State var imageBasedMemoryVM = ImageBasedMemoryViewModel.shared
    
    @FocusState.Binding var isTextEditorFocused: Bool
    
    @Binding var textFieldText: String
    
    // MARK: BODY
    var body: some View {
        MessegeTextFieldBarView(textFieldText: $textFieldText,
                                isEnabled: Binding.constant(true),
                                placeholder: "Add a caption...",
                                textFieldBackgroundColor: Binding.constant(.white),
                                fullBackgroundColor: Binding.constant(.clear),
                                dividerOpacity: 0,
                                textForegroundColor: .black,
                                textFieldVerticalPadding: 7,
                                buttonHeight: .constant(35),
                                buttonColor1: .constant(.white),
                                buttonColor2: .constant(.white),
                                buttonColor3: .constant(.black),
                                isAlwaysEnabled: true,
                                specialBlackCondition: .constant(false),
                                onClicked: {
            
            imageBasedMemoryVM.DrawingContentAsImage = ImageWithDrawingsView(isTextEditorFocused: $isTextEditorFocused).asImage()
            
            let caption: String = imageBasedMemoryVM.textEditortext
            
            imageBasedMemoryVM.resetCameraSheet()
            
            if let uiImage = imageBasedMemoryVM.DrawingContentAsImage {
                imageBasedMemoryVM.submitImageBasedMemoryToFirestore(
                    imageBasedMemoryImage: uiImage,
                    caption: caption) { _ in }
            } else {
                print("Error Creating Drawing Content As An Image ☠️☠️☠️")
            }
        })
            .focused($isTextEditorFocused)
            .padding(.bottom)
    }
}

// MARK: PREVIEWS
struct ImageBasedMemoryTextFieldView_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: Bool
    
    static var previews: some View {
        VStack {
            Spacer()
            ImageBasedMemoryTextFieldView(isTextEditorFocused: $fieldInFocus, textFieldText: Binding.constant(""))
                .preferredColorScheme(.dark)
        }
        .environmentObject(MemoriesViewModel())
        .environmentObject(ColorTheme())
        .environmentObject(ImageBasedMemoryViewModel())
    }
}
