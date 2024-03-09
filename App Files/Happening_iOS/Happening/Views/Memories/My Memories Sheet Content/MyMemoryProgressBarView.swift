//
//  MyMemoryProgressBarView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-02.
//

import SwiftUI

struct MyMemoryProgressBarView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    let tag: Int
    
    let memoriesData: [MyMemoriesModel]
    
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
                if memoriesVM.selectedMyMemoryIndex == tag {
                    
                    if count < 1 {
                        progressBarAmount = 0
                        count += 1
                    }
                    
                    if(progressBarAmount < 100) {
                        progressBarAmount += 0.2
                    }
                    
                    if(progressBarAmount >= 100) {
                        if memoriesVM.selectedMyMemoryIndex == memoriesData.count-1 {
                            showSheet = false
                        } else {
                            memoriesVM.selectedMyMemoryIndex += 1
                        }
                    }
                } else {
                    if tag < memoriesVM.selectedMyMemoryIndex {
                        progressBarAmount = 100
                    } else {
                        progressBarAmount = 0
                    }
                }
            }
            .onReceive(memoriesVM.memoryProgressBartimer2) { _ in
                if tag < memoriesVM.selectedMyMemoryIndex {
                    progressBarAmount = 100
                }
            }
    }
}
