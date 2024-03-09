//
//  ImageTester.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-01.
//

import SwiftUI

struct ImageTester: View {
    
    @State private var vm = MemoriesViewModel.shared
    
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        Image("sampleImage")
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth, height: screenHeight)
            .blur(radius: 10)
            .overlay(MemoryLoadingProgressView())
            .edgesIgnoringSafeArea(.all)
    }
}

struct ImageTester_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageTester()
                .preferredColorScheme(.dark)
            
            ImageTester()
        }
        .environmentObject(MemoriesViewModel())
    }
}
