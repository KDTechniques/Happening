//
//  TextBasedMemorySheetView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-06.
//

import SwiftUI

struct TextBasedMemorySheetView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    
    @FocusState private var isTextFieldEditorFocused: Bool
    
    // MARK: BODY
    var body: some View {
        ZStack {
            TextBasedMemoryBackgroundColorView()
            
            TextBasedMemoryOverlappingActionButtonsView()
            
            TextBasedMemoryTextEditorView(isTextFieldEditorFocused: $isTextFieldEditorFocused)
            
            TypeATextBasedMemoryTextView(isTextFieldEditorFocused: $isTextFieldEditorFocused)
            
            MaxLimitsReachedAlertView()
        }
        .accentColor(Color.white)
        .onAppear {
            memoriesVM.pauseMemoryUploadDTCalculatorTimer()
            
            textBasedMemoryVM.onAppearOfTextBasedMemorySheetView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isTextFieldEditorFocused = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isTextFieldEditorFocused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.isTextFieldEditorFocused = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.isTextFieldEditorFocused = true
                        }
                    }
                }
            }
        }
        .onDisappear {
            memoriesVM.resumeMemoryUploadDTCalculatorTimer()
        }
    }
}

// MARK: PREVIEWS
struct TextBasedMemorySheetView_Previews: PreviewProvider {
    static var previews: some View {
        TextBasedMemorySheetView()
            .environmentObject(ColorTheme())
            .environmentObject(MemoriesViewModel())
            .environmentObject(TextBasedMemoryViewModel())
    }
}
