//
//  MyFollowingsMemoryProgressBarView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-09.
//

import SwiftUI

struct MyFollowingsMemoryProgressBarView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    let tag: Int
    
    @Binding var memoriesData: [FollowingsMemoriesModel]
    
    @State private var progressBarAmount: CGFloat = .zero
    
    @Binding var showSheet: Bool
    
    @Binding var count: Int
    
    // MARK: BODY
    var body: some View {
        ProgressView(value: progressBarAmount, total: 100.1)
            .progressViewStyle(LinearProgressViewStyle())
            .tint(.white)
            .background(.secondary)
            .cornerRadius(.infinity)
            .tag(tag)
            .onReceive(memoriesVM.memoryProgressBartimer1) { _ in
                if memoriesVM.selectedFollowingsMemoryIndex == tag {
                    
                    if count < 1 {
                        progressBarAmount = 0
                        count += 1
                    }
                    
                    if(progressBarAmount < 100) {
                        progressBarAmount += 0.2
                    }
                    
                    if(progressBarAmount >= 100) {
                        if memoriesVM.selectedFollowingsMemoryIndex == memoriesData.count-1 {
                            showSheet = false
                        } else {
                            memoriesVM.selectedFollowingsMemoryIndex += 1
                        }
                    }
                } else {
                    if tag < memoriesVM.selectedFollowingsMemoryIndex {
                        progressBarAmount = 100
                    } else {
                        progressBarAmount = 0
                    }
                }
            }
            .onReceive(memoriesVM.memoryProgressBartimer2) { _ in
                if tag < memoriesVM.selectedFollowingsMemoryIndex {
                    progressBarAmount = 100
                }
            }
    }
}
