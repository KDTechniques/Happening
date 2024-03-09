//
//  MyFollowingsMemoriesProgressBarsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-09.
//

import SwiftUI

struct MyFollowingsMemoriesProgressBarsView: View {
    
    // MARK: PROPERTIES
    
    @Binding var memoriesData: [FollowingsMemoriesModel]
    
    @Binding var showSheet: Bool
    @Binding var count: Int
    
    // MARK: BODY
    var body: some View {
        HStack {
            ForEach(0..<memoriesData.count, id: \.self) { index in
                MyFollowingsMemoryProgressBarView(
                    tag: index,
                    memoriesData: $memoriesData,
                    showSheet: $showSheet,
                    count: $count
                )
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
