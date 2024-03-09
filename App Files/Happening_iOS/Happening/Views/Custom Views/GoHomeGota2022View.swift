//
//  #GoHomeGota2022View.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-04-08.
//

import SwiftUI

struct GoHomeGota2022View: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var color: ColorTheme
    
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    @State private var offset: CGFloat = 0
    
    // MARK: BODY
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(1...3*3, id: \.self) { _ in
                    Text("#GoHomeGota2022")
                        .frame(width: screenWidth/3)
                }
            }
            .frame(maxWidth: screenWidth)
            .font(.caption2)
            .foregroundColor(color.accentColor)
            .lineLimit(1)
            .offset(x: offset)
            .onAppear {
                let baseAnimation = Animation.linear(duration: 4)
                let repeated = baseAnimation.repeatForever(autoreverses: false)
                withAnimation(repeated) {
                    offset = -screenWidth
                }
            }
            
            Spacer()
        }
        .offset(y: 35)
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: PREVIEWS
struct GoHomeGota2022View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GoHomeGota2022View()
                .preferredColorScheme(.dark)
            
            GoHomeGota2022View()
        }
        .environmentObject(ColorTheme())
    }
}
