//
//  EmojiButtonView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-05-26.
//

import SwiftUI

struct EmojiButtonView: View {
    
    // MARK: PROPERTIES
    let emoji: String
    let selectedEmoji: ReactorEmojiTypes
    var action: () -> Void
    
    @State private var scaleValue: CGFloat = 1.4
    @State private var frameWidth: CGFloat = 50
    
    // MARK: BODY
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(UIColor.systemGray2))
                .frame(width: frameWidth)
                .opacity(selectedEmoji.rawValue == emoji ? 1 : 0)
            
            Text(emoji)
                .scaleEffect(scaleValue)
                .onTapGesture {
                    frameWidth = 0
                    
                    withAnimation(.easeInOut(duration: 0.1)) {
                        scaleValue = 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            scaleValue = 1.4
                        }
                        
                        withAnimation(.easeInOut(duration: 0.1)) {
                            frameWidth = 50
                        }
                    }
                    
                    action()
                }
        }
        .frame(width: 50, height: 50)
    }
}

// MARK: PREVIEWS
struct CustomEmojiButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmojiButtonView(emoji: "❤️", selectedEmoji: .heart, action: { })
                .preferredColorScheme(.dark)
            
            EmojiButtonView(emoji: "❤️", selectedEmoji: .heart, action: { })
        }
    }
}
