//
//  MyMemoriesDottedCircle.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-02.
//

import SwiftUI

struct MyMemoriesDottedCircle: View {
    
    // MARK: PROPETIES
    @Environment(\.colorScheme) var colorScheme
    
    let defaultPosition: Double = 45*3
    
    let count: Int
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 1.8)
                .frame(width: 56, height: 56)
                .foregroundColor(Color(UIColor.systemGray3))
            
            if count > 1 {
                ForEach(0..<count, id: \.self) { index in
                    Image(systemName: "line.diagonal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .rotationEffect(.degrees(defaultPosition))
                        .foregroundColor(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
                        .offset(y: -30)
                        .rotationEffect(.degrees(Double((360/count)*index)))
                        .opacity(count > 20 ? 0 : 1)
                }
            }
            
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.clear)
        }
        .clipShape(Circle())
    }
}

// MARK: PREVIEWS
struct MyMemoriesDottedCircle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyMemoriesDottedCircle(count: 10)
                .preferredColorScheme(.dark)
            
            MyMemoriesDottedCircle(count: 20)
        }
    }
}
