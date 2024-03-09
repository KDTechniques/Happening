//
//  CaptionView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-09.
//

import SwiftUI

struct CaptionView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    @Binding var memoriesData: [FollowingsMemoriesModel]
    
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    @Binding var isPresentedViewersSheet: Bool
    
    // MARK: BODY
    var body: some View {
        VStack {
            Text(memoriesData[memoriesVM.selectedFollowingsMemoryIndex].caption)
                .font(.title3)
                .fontWeight(.semibold)
            
            RoundedRectangle(cornerRadius: .infinity)
                .fill(.white)
                .frame(height: 1)
            
                .padding(.horizontal)
        }
        .opacity((memoriesData[memoriesVM.selectedFollowingsMemoryIndex].memoryType == .imageBased && !memoriesData[memoriesVM.selectedFollowingsMemoryIndex].caption.isEmpty) ? 1 : 0)
        .foregroundColor(.white)
    }
}
