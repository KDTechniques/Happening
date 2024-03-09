//
//  TextBasedMemoryOverlappingActionButtonsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-07.
//

import SwiftUI

struct TextBasedMemoryOverlappingActionButtonsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    
    // MARK: BODY
    var body: some View {
        VStack {
            HStack{
                Button {
                    textBasedMemoryVM.resetTextBasedMemorySheet()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.heavy))
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        textBasedMemoryVM.changeFontStyle()
                    } label: {
                        Text("Tt")
                            .font(.custom(textBasedMemoryVM.selectedFontType,
                                          size: textBasedMemoryVM.customFontSizes1[textBasedMemoryVM.selectedFontIndex]))
                            .frame(width: 42, height: 34)
                    }
                    
                    Button {
                        textBasedMemoryVM.changeBackgroundColor()
                    } label: {
                        Image(systemName: "paintpalette.fill")
                    }
                }
            }
            .foregroundColor(Color.white)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
}

// MARK: PREVIEWS
struct TextBasedMemoryOverlappingActionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TextBasedMemoryBackgroundColorView()
            
            TextBasedMemoryOverlappingActionButtonsView()
        }
        .environmentObject(MemoriesViewModel())
        .environmentObject(TextBasedMemoryViewModel())
    }
}
