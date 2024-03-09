//
//  MemoryLoadingProgressView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-06.
//

import SwiftUI

struct MemoryLoadingProgressView: View {
    // MARK: PROPERTEIS
    @EnvironmentObject var memoriesVM: MemoriesViewModel
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 50)
            
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(lineWidth: 2)
                .fill(Color(UIColor.systemGray2))
                .frame(width: 44)
                .rotationEffect(.degrees(-100))
                .rotationEffect(.degrees(memoriesVM.rotationAmount))
                .preferredColorScheme(.dark)
        }
        .onAppear {
            memoriesVM.rotationAmount = 0
            let baseAnimation = Animation.easeInOut(duration: 1.4)
            let repeated = baseAnimation.repeatForever(autoreverses: false)
            withAnimation(repeated) {
                memoriesVM.rotationAmount += 360
            }
        }
    }
}

// MARK: PREVIEWS
struct MemoryLoadingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryLoadingProgressView()
            .environmentObject(MemoriesViewModel())
    }
}
