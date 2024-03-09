//
//  MyMemoriesProgressBarsView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-01.
//

import SwiftUI

struct MyMemoriesProgressBarsView: View {
    
    // MARK: PROPERTIES
    
    let memoriesData: [MyMemoriesModel]
    
    @Binding var showSheet: Bool
    @Binding var count: Int
    
    // MARK: BODY
    var body: some View {
        HStack {
            ForEach(0..<memoriesData.count, id: \.self) { index in
                MyMemoryProgressBarView(
                    tag: index,
                    memoriesData: memoriesData,
                    showSheet: $showSheet,
                    count: $count
                )
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
