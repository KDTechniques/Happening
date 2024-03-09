//
//  TextBasedMemoryTextEditorView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-07.
//

import SwiftUI

struct TextBasedMemoryTextEditorView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    @FocusState.Binding var isTextFieldEditorFocused: Bool
    
    // MARK: BODY
    var body: some View {
        TextEditor(text: $textBasedMemoryVM.textEditortext)
            .focused($isTextFieldEditorFocused)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: TextBasedMemoryViewModel.shared.textEditorFrameHeight)
        //                .background(Color.red) // uncomment when debuging
            .padding(.top, 60)
            .padding(.bottom)
            .padding(.horizontal, 20)
            .font(.custom(TextBasedMemoryViewModel.shared.selectedFontType, size: TextBasedMemoryViewModel.shared.customFontSizes3[TextBasedMemoryViewModel.shared.selectedFontIndex]))
            .multilineTextAlignment(TextBasedMemoryViewModel.shared.textAlignment)
            .foregroundColor(Color.white)
            .onChange(of: TextBasedMemoryViewModel.shared.textEditortext) { character in
                TextBasedMemoryViewModel.shared.limitText(700)
                TextBasedMemoryViewModel.shared.onChangeOfTextEditorText(character: character)
            }
    }
}

// MARK: PREVIEWS
struct TextBasedMemoryTextEditorView_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: Bool
    
    static var previews: some View {
        TextBasedMemoryTextEditorView(isTextFieldEditorFocused: $fieldInFocus)
            .environmentObject(MemoriesViewModel())
            .environmentObject(TextBasedMemoryViewModel())
    }
}
