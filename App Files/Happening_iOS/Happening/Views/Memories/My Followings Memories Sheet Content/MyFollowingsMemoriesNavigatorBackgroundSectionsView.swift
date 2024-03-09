//
//  MyFollowingsMemoriesNavigatorBackgroundSectionsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-09.
//

import SwiftUI

struct MyFollowingsMemoriesNavigatorBackgroundSectionsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    @Binding var isPresentedViewersSheet: Bool
    @Binding var count: Int
    @Binding var shallPause: Bool
    @Binding var showSheet: Bool
    
    @Binding var memoriesData: [FollowingsMemoriesModel]
    
    // MARK: BODY
    var body: some View {
        HStack(spacing: 0) {
            Color(.black)
                .opacity(0.001)
                .onTapGesture {
                    if memoriesVM.selectedFollowingsMemoryIndex > 0 {
                        memoriesVM.selectedFollowingsMemoryIndex -= 1
                    }
                    
                    count = 0
                    
                    memoriesVM.resumeMemoryProgressBar()
                    
                    shallPause = false
                }
            
            Color(.black)
                .opacity(0.001)
                .onTapGesture {
                    shallPause.toggle()
                    if shallPause {
                        memoriesVM.pauseMemoryProgressBar()
                    } else {
                        memoriesVM.resumeMemoryProgressBar()
                    }
                }
            
            Color(.black)
                .opacity(0.001)
                .onTapGesture {
                    if memoriesVM.selectedFollowingsMemoryIndex < memoriesData.count-1 {
                        memoriesVM.selectedFollowingsMemoryIndex += 1
                        
                        memoriesVM.resumeMemoryProgressBar()
                        
                        shallPause = false
                    } else {
                        showSheet = false
                    }
                }
        }
        .disabled(isPresentedViewersSheet)
        .onTapGesture {
            withAnimation(.spring()) {
                isPresentedViewersSheet = false
            }
            
            memoriesVM.resumeMemoryProgressBar()
        }
    }
}
