//
//  TypeATextBasedMemoryTextView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-07.
//

import SwiftUI

struct TypeATextBasedMemoryTextView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    
    @FocusState.Binding var isTextFieldEditorFocused: Bool
    
    // MARK: BODY
    var body: some View {
        if(textBasedMemoryVM.textEditortext.count == 0) {
            Text("Type a memory")
                .font(.custom(textBasedMemoryVM.selectedFontType, size: textBasedMemoryVM.customFontSizes2[textBasedMemoryVM.selectedFontIndex]))
                .foregroundColor(.white.opacity(0.5))
                .padding(.top, 40)
                .onTapGesture { isTextFieldEditorFocused = true }
        }
    }
}

// MARK: PREVIEWS
struct TypeATextBasedMemoryTextView_Previews: PreviewProvider {
    
    @FocusState static var fieldInFocus: Bool
    
    static var previews: some View {
        ZStack {
            TextBasedMemoryBackgroundColorView()
            
            TypeATextBasedMemoryTextView(isTextFieldEditorFocused: $fieldInFocus)
        }
        .environmentObject(MemoriesViewModel())
        .environmentObject(TextBasedMemoryViewModel())
    }
}
