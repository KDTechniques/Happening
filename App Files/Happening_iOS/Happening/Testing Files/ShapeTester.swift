//
//  ShapeTester.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-08.
//

import SwiftUI

struct ShapeTester: View {
    
    @State private var count: CGFloat = 6
    
    var body: some View {
        ZStack {
            
            Circle()
                .trim(from: 0, to: 1/count)
                .stroke(lineWidth: 2)
                .fill(.green)
                .rotationEffect(.degrees(Double((360/count)*0)))
            
            
            Circle()
                .trim(from: 0, to: 1/count)
                .stroke(lineWidth: 2)
                .fill(.blue)
                .rotationEffect(.degrees(Double((360/count)*1)))
            
            
            Circle()
                .trim(from: 0, to: 1/count)
                .stroke(lineWidth: 2)
                .fill(.red)
                .rotationEffect(.degrees(Double((360/count)*2)))
            
            
            Circle()
                .trim(from: 0, to: 1/count)
                .stroke(lineWidth: 2)
                .fill(.purple)
                .rotationEffect(.degrees(Double((360/count)*3)))
            
            
            Circle()
                .trim(from: 0, to: 1/count)
                .stroke(lineWidth: 2)
                .fill(.orange)
                .rotationEffect(.degrees(Double((360/count)*4)))
            
            
            Circle()
                .trim(from: 0, to: 1/count)
                .stroke(lineWidth: 2)
                .fill(.yellow)
                .rotationEffect(.degrees(Double((360/count)*5)))
            
        }
        .frame(width: 100)
        .rotationEffect(.degrees(Double((360/count))))
    }
}

struct ShapeTester_Previews: PreviewProvider {
    static var previews: some View {
        ShapeTester()
    }
}
