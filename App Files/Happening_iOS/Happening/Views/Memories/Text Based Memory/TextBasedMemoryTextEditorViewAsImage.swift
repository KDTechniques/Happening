//
//  TextBasedMemoryTextEditorViewAsImage.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-06.
//

import SwiftUI

import SwiftUI

struct TextBasedMemoryTextEditorViewAsImage: View {
    
    // MARK: PROPERTIES
    @State var textBasedMemoryVM = TextBasedMemoryViewModel.shared
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Color(textBasedMemoryVM.__colorName)
            
            TextEditor(text: $textBasedMemoryVM.__textEditortext)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: textBasedMemoryVM.__textEditorFrameHeight)
                .padding(.top, 60)
                .padding(.bottom)
                .padding(.horizontal, 20)
                .font(.custom(textBasedMemoryVM.__fontName, size: textBasedMemoryVM.__customFontSizes3[textBasedMemoryVM.__selectedFontIndex]))
                .multilineTextAlignment(textBasedMemoryVM.__textAlignment)
                .foregroundColor(Color.white)
                .offset(y: -25)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
