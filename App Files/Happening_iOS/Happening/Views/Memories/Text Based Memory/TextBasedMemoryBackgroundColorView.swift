//
//  TextBasedMemoryBackgroundColorView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-07.
//

import SwiftUI

struct TextBasedMemoryBackgroundColorView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    
    // MARK: BODY
    var body: some View {
        Color(textBasedMemoryVM.backgroundColorsArray[textBasedMemoryVM.selectedColorIndex])
            .edgesIgnoringSafeArea(.all)
    }
}

// MARK: PREVIEWS
struct TextBasedMemoryBackgroundColorView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TextBasedMemoryBackgroundColorView()
            
            TextBasedMemoryOverlappingActionButtonsView()
        }
        .environmentObject(MemoriesViewModel())
        .environmentObject(TextBasedMemoryViewModel())
    }
}
