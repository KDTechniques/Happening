//
//  CaptionNViewersButtonView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-01.
//

import SwiftUI

struct CaptionNViewersButtonView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    let memoriesData: [MyMemoriesModel]
    
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    @Binding var isPresentedViewersSheet: Bool
    
    // MARK: BODY
    var body: some View {
        VStack {
            VStack {
                Text(memoriesData[memoriesVM.selectedMyMemoryIndex].caption)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(.white)
                    .frame(height: 1)
                
                    .padding(.horizontal)
            }
            .opacity((memoriesData[memoriesVM.selectedMyMemoryIndex].memoryType == .imageBased && !memoriesData[memoriesVM.selectedMyMemoryIndex].caption.isEmpty) ? 1 : 0)
            
            Button {
                withAnimation(.spring()) {
                    isPresentedViewersSheet = true
                    memoriesVM.pauseMemoryProgressBar()
                    memoriesVM.resumeMemoryUploadDTCalculatorTimer()
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "chevron.compact.up")
                        .font(.title.weight(.semibold))
                    
                    HStack(spacing: 3) {
                        Image(systemName: "eye.fill")
                            .font(.caption)
                        
                        Text("\(memoriesData[memoriesVM.selectedMyMemoryIndex].seenersData.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                .background(.black.opacity(0.001))
            }
        }
        .foregroundColor(.white)
    }
}
