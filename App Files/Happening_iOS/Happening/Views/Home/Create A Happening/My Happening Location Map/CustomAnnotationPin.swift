//
//  CustomPin.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-04.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomAnnotationPin: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var frameSize: CGFloat = 48
    @State private var opacity: CGFloat = 0.5
    
    let photoURL: String
    let notationText: String
    let isDynamicNotationTextColor: Bool
    
    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: 48, height: 48)
            .background(
                Circle()
                    .fill(ColorTheme.shared.accentColor.opacity(opacity))
                    .frame(width: frameSize, height: frameSize)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 2)
                        let repeated = baseAnimation.repeatForever(autoreverses: false)
                        withAnimation(repeated) {
                            frameSize = 70
                            opacity = 0
                        }
                    }
            )
            .overlay {
                WebImage(url: URL(string: photoURL))
                    .resizable()
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            }
            .overlay {
                Circle()
                    .fill(.white)
                    .frame(width: 3.5, height: 3.5)
                    .background {
                        Ellipse()
                            .fill(.black.opacity(0.2))
                            .blur(radius: 3)
                            .frame(width: 20, height: 6)
                    }
                    .offset(x: 0, y: 30)
            }
            .offset(x: 0, y: -30)
            .overlay {
                Text(notationText)
                    .font(.system(size: 10))
                    .foregroundColor(isDynamicNotationTextColor ? .primary : .white)
                    .fixedSize(horizontal: true, vertical: false)
                    .offset(x: 0, y: 14)
            }
    }
}

struct CustomAnnotationPin_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomAnnotationPin(photoURL: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic", notationText: "Your Happening Location", isDynamicNotationTextColor: false)
            
            CustomAnnotationPin(photoURL: "https://nokiatech.github.io/heif/content/images/ski_jup_1440x960.heic", notationText: "Your Happening Location", isDynamicNotationTextColor: false)
                .preferredColorScheme(.dark)
        }
        .environmentObject(ColorTheme())
    }
}
