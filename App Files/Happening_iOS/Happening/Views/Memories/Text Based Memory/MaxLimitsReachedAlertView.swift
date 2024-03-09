//
//  MaxLimitsReachedAlertView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-07.
//

import SwiftUI

struct MaxLimitsReachedAlertView: View {
    
    // MARK: PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    @EnvironmentObject var textBasedMemoryVM: TextBasedMemoryViewModel
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    let defaults = UserDefaults.standard
    
    // MARK: BODY
    var body: some View {
        VStack {
            Spacer()
            
            Text("Your memory update cannot exceed 700 characters or 12 lines.")
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                .padding(.horizontal)
            // set opacity 0 as 1 for testing
                .opacity(textBasedMemoryVM.isReachedMaxCharactersOrLines ? 1 : 0)
            
            HStack {
                Spacer()
                
                Button {
                    textBasedMemoryVM.submitTextBasedMemoryToFirestore(textBasedMemoryAsImage: TextBasedMemoryAsImageView().asImage()) { _ in }
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .rotationEffect(.degrees(45))
                        .accentColor(color.accentColor)
                        .background(color.accentColor == Color("AccentColorContrast")
                                    ? (colorScheme == .light ? Circle().fill(Color.white) : Circle().fill(Color.black))
                                    : Circle().fill(Color.white))
                }
                .disabled(textBasedMemoryVM.textEditortext.count > 0 ? false : true)
                .scaleEffect(textBasedMemoryVM.scaleEffectValueOfTextBasedMemorySubmitButton)
                .padding()
            }
        }
    }
}

// MARK: PREVIEWS
struct MaxLimitsReachedAlertView_Previews: PreviewProvider {
    static var previews: some View {
        MaxLimitsReachedAlertView()
            .environmentObject(MemoriesViewModel())
            .environmentObject(TextBasedMemoryViewModel())
            .environmentObject(ColorTheme())
    }
}
