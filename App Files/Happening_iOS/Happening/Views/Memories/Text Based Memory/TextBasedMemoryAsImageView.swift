//
//  TextBasedMemoryAsImageView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-30.
//

import SwiftUI

struct TextBasedMemoryAsImageView: View {
    
    // MARK: PROPERTIES
    @State var textBasedMemoryVM = TextBasedMemoryViewModel.shared
    @FocusState var fieldInFocus: Bool
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Color(textBasedMemoryVM.backgroundColorsArray[textBasedMemoryVM.selectedColorIndex])
            
            TextEditor(text: $textBasedMemoryVM.textEditortext)
                .focused($fieldInFocus)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: textBasedMemoryVM.textEditorFrameHeight)
            //                .background(Color.red) // uncomment when debuging
                .padding(.top, 60)
                .padding(.bottom)
                .padding(.horizontal, 20)
                .font(.custom(textBasedMemoryVM.selectedFontType, size: textBasedMemoryVM.customFontSizes3[textBasedMemoryVM.selectedFontIndex]))
                .multilineTextAlignment(textBasedMemoryVM.textAlignment)
                .foregroundColor(Color.white)
                .onChange(of: textBasedMemoryVM.textEditortext) { character in
                    textBasedMemoryVM.limitText(700)
                    textBasedMemoryVM.onChangeOfTextEditorText(character: character)
                }
                .offset(y: -25) // remove this after making things perfect
        }
        .edgesIgnoringSafeArea(.all)
    }
}
