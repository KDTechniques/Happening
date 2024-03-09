//
//  CustomMovingAnnotationPin.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-04.
//

import SwiftUI

struct CustomMovingAnnotationPin: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Circle()
            .fill(.primary)
            .frame(width: 32)
            .overlay {
                Image("LogoIcon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .frame(width: 28)
            }
            .clipShape(Circle())
            .background {
                Rectangle()
                    .fill(.primary)
                    .frame(width: 2, height: 20)
                    .offset(x: 0, y: 23)
            }
            .offset(x: 0, y: -32)
    }
}

struct CustomMovingAnnotationPin_Previews: PreviewProvider {
    static var previews: some View {
        CustomMovingAnnotationPin()
    }
}
