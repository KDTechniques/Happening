//
//  FollowingsMemoriesDottedCircle.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-08.
//

import SwiftUI

struct FollowingsMemoriesDottedCircle: View {
    
    // MARK: PROPETIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var color: ColorTheme
    
    let count: Int
    
    let isAllSeen: Bool
    
    let defaultPosition: Double = 45*3
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 1.8)
                .frame(width: 56, height: 56)
                .foregroundColor(isAllSeen ? Color(UIColor.systemGray3) : color.accentColor)
            
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
struct FollowingsMemoriesDottedCircle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Color(UIColor.secondarySystemBackground)
                
                FollowingsMemoriesDottedCircle(count: 3, isAllSeen: false)
            }
            .edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
            
            FollowingsMemoriesDottedCircle(count: 8, isAllSeen: true)
        }
        .environmentObject(ColorTheme())
    }
}
